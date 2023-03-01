defmodule Train do

  def take(_, 0) do [] end
  def take([h|t], n) do
    if n > 0 do
      [h| take(t, n-1)]
    else
      [h|t]
    end
  end

  def drop(train, 0) do train end
  def drop([_|t], n) when n > 0 do
    drop(t, n-1)
  end

  def append([], t2) do t2 end
  def append(t1, t2) do
    t1 ++ t2
  end

  def member([], _) do false end
  def member([h|t], y) do
    if(h==y) do
      true
    else
      member(t, y)
    end
  end

  def position([y|_],y) do 1 end
  def position([_|t], y) do
    position(t, y) + 1
  end


  def split([y|t], y) do {[], t} end
  def split([h|t], y) do
    {t1, t2} = split(t, y)
    {[h|t1], t2}
  end

  def main([], n) do {n, [], []} end
  def main([h|t], n) do
    {n, remain, take} = main(t, n)
    if(n==0) do
      {0, [h|remain], take}
    else
      {n-1, remain, [h|take]}
    end
  end
  
end
