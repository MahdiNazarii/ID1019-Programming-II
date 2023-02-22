defmodule EnvList do

  def new() do [] end

  def add([], key, value) do [{key, value}] end
  def add([{k,v}|t], key, value) do
    if(k == key) do
      [{k, value}|t]
    else
      [{k,v}] ++ add(t, key, value)
    end
  end

  def lookup([], _) do nil end
  def lookup([{k,v}|t], key) do
    if(k == key) do
      {k,v}
    else
      lookup(t, key)
    end
  end

  def remove([], _) do [] end
  def remove([{k,v}|t], key) do
    if(k == key) do
     t
    else
      [{k,v}] ++ remove(t, key)
    end
  end



end
