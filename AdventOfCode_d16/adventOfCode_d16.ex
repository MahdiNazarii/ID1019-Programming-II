defmodule AdventOfCode_d16 do
  def test() do
    test =
    [
      "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
      "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
      "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
      "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
      "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
      "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
      "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
      "Valve HH has flow rate=22; tunnel leads to valve GG",
      "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
      "Valve JJ has flow rate=21; tunnel leads to valve II"
    ]

    Enum.map(test, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_, valve | _ ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_,_,_,_, _| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, &String.to_atom(String.trim(&1,",")))
      {valve, {rate, valves}}
    end)
  end

  def dataToList() do
    file = File.read!("/Users/mahdinazari/Documents/Programmering 2/Assignments/AdventOfCode_d16/scanOutput.txt")
    outer_split = String.split(file, "\n")

    Enum.map(outer_split, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_, valve | _ ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_,_,_,_, _| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, &String.to_atom(String.trim(&1,",")))
      {valve, {rate, valves}}
    end)
  end

  def task() do
    {t, {p, path}} = :timer.tc(fn -> task(30) end)
    :io.format("Execution Time:[us] ~w\n", [t])
    :io.format("Pressure released: ~w\n", [p])
    :io.format("Path: ~w\n", [path])
  end

  def task(t) do
    #valvesList = test()
    valvesList = dataToList()
    start = :AA

    closed_valves = Enum.map((Enum.filter( valvesList, fn({_,{rate,_}}) -> rate != 0 end)), fn({valve, _}) -> valve end)
    {max, path, _} = search(start, t, closed_valves, [], 0, valvesList, [], Map.new())
    {max, Enum.reverse(path)}
  end

  def check(valve, t, closed_valves, open_valves, rate, valvesList, path, mem) do
    case mem[{valve, t, open_valves}] do
      nil ->
	      ## :io.format("searching ~w ~w ~w\n", [valve, t, open_valves])
	      {max, path, mem} = search(valve, t, closed_valves, open_valves, rate, valvesList, path, mem)
	      mem = Map.put(mem, {valve, t,  open_valves}, {max,path})
	      {max, path, mem}
      {max, path} ->
	      {max, path, mem}
    end
  end

  def search(_valve, 0, _closed_valves, _open_valves, _rate, _valvesList, path, mem) do
    {0, path, mem}
  end

  def search(_valve, t, [], _open_valves, rate, _valvesList, path, mem) do
    ## all valves are  open_valves
    {rate*t, path, mem}
  end

  def search(valve, t, closed_valves, open_valves, rate, valvesList, path, mem) do

    {valve_rate, tunnels} = valvesList[valve]

    {max, pathx, mem} = if Enum.member?(closed_valves, valve) do
      ##  open_valves the valve is one option
      removed = List.delete(closed_valves, valve)
      {max, pathx, mem} = check(valve, t-1, removed, [valve| open_valves], rate+valve_rate, valvesList, [valve|path], mem)
      max = max + rate
      {max, pathx, mem}
    else
      ## if we can not open_valves the valve we could just stay
      {rate*t, path, mem}
  end

  Enum.reduce(tunnels, {max, pathx, mem},
      fn(nxt, {max, pathx, mem}) ->
          # moving to nxt
	        {maxy, pathy, mem} = check(nxt, t-1, closed_valves, open_valves, rate, valvesList, path, mem)
          maxy = maxy + rate
	        if (maxy > max) do
	          ## moving to nxt was better
	          {maxy, pathy, mem}
	        else
	          {max, pathx, mem}
	        end
      end)
  end

end
