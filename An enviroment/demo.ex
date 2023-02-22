defmodule Demo do
  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)
    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
                      EnvList.add(list, e, :foo)
                      end)
    tree = Enum.reduce(seq, EnvTree.new(), fn(e, tree) ->
                      EnvTree.add(tree, e, :foo)
                      end)
    map = Enum.reduce(seq, Map.new(), fn(e, map) ->
                      Map.put(map, e, :foo)
                      end)

    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    {addL, _} = :timer.tc(fn() ->
                Enum.each(seq, fn(e) ->
                EnvList.add(list, e, :foo)
                end)
              end)
    {addT, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.add(tree, e, :foo)
      end)
    end)

    {addM, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      Map.put(map, e, :foo)
      end)
    end)

    {lookupL, _} = :timer.tc(fn() ->
                  Enum.each(seq, fn(e) ->
                  EnvList.lookup(list, e)
                  end)
                end)
    {lookupT, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.lookup(tree, e)
      end)
    end)

    {lookupM, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      Map.get(map, e)
      end)
    end)

    {removeL, _} = :timer.tc(fn() ->
                  Enum.each(seq, fn(e) ->
                  EnvList.remove(list, e)
                  end)
                end)
    {removeT, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      EnvTree.remove(tree, e)
      end)
    end)

    {removeM, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
      Map.delete(map, e)
      end)
    end)

    {i, addL, lookupL, removeL, addT, lookupT, removeT, addM, lookupM, removeM}
    #{map, list, tree}
  end


  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark with ~w operations, time per operation in ns\n", [n])
    :io.format("~6.s~12.s~36.s~36.s\n", ["n", "add", "lookup", "remove"])
    :io.format("~18.s~12.s~12.s~12.s~12.s~12.s~12.s~12.s~12.s\n", ["list", "tree", "map", "list", "tree", "map", "list", "tree", "map"])

      Enum.each(ls, fn (i) ->
      {i, tla, tll, tlr, tta, ttl, ttr, tma, tml, tmr} = bench(i, n)

    :io.format("~6.w~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f~12.2f\n", [i, (tla*1000)/n, (tta*1000)/n, (tma*1000)/n, (tll*1000)/n, (ttl*1000)/n, (tml*1000)/n, (tlr*1000)/n, (ttr*1000)/n, (tmr*1000)/n])
    end)
    end
end
