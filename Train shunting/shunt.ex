defmodule Shunt do

  def find([], []) do [] end
  def find(xs, [h|ys]) do
    {hs, ts} = Train.split(xs, h)
    to_two = length(hs)
    to_one = length(ts)

    [{:one, to_one+1}, {:two, to_two}, {:one, -(to_one+1)}, {:two, -to_two} | find(Train.append(ts, hs), ys)]
  end


  def few([], []) do [] end
  def few([h|xs], [h|ys]) do few(xs, ys) end
  def few(xs, [h|ys]) do
    {hs, ts} = Train.split(xs, h)
    to_two = length(hs)
    to_one = length(ts)

    [{:one, to_one+1}, {:two, to_two}, {:one, -(to_one+1)}, {:two, -to_two} | few(Train.append(ts, hs), ys)]
  end

  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
        ms
    else
        compress(ns)
    end
  end

  def rules([]) do [] end
  def rules([{h, n}, {h, m}|t]) do rules([{h, n+m}|t]) end
  def rules([{_, 0} |t]) do rules(t) end
  def rules([h|t]) do [h|rules(t)] end


  # optional task
  def fewer(ms, ys) do fewer(ms, [], [], ys) end
  def fewer(_, _, _, []) do [] end
  def fewer(ms, os, ts, [y|ys]) do
    cond do
      Train.member(ms, y) ->
        {hs, ts} = Train.split(ms, y)
        to_two = length(hs)
        to_one = length(ts)
        rules([{:one, to_one+1}, {:two, to_two}, {:one, -1} | fewer([y], ts, hs, ys)])

      Train.member(os, y) ->
        indx = Train.position(os, y)
        rules([{:one, -(indx-1)}, {:two, indx-1}, {:one, -1} | fewer(ms, os, ts, ys)])

      Train.member(ts, y) ->
        indx = Train.position(ts, y)
        rules([{:two, -(indx-1)}, {:one, indx-1}, {:two, -1} | fewer(ms, os, ts, ys)])
    end
  end
end
