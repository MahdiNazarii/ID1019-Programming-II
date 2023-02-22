defmodule EnvTree do

  def new() do :nil end


  # TO ADD AN ELEMEN IN A TREE
  def add(nil, key, value) do
    # ...adding a key-value pair to an empty tree ..
    {:node, key, value, nil, nil}
  end
  def add({:node, key, _, left, right}, key, value) do
  # ...if the key is found we replace it ..
  {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) when key < k do
  # ...return a tree that looks like the one we have
  # but where the left branch has been updated ...
  {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) do
  #... same thing but instead update the right banch
  {:node, k, v, left, add(right, key, value)}
  end



  # TO LOOKUP AN ELEMEN IN A TREE
  def lookup(nil, _) do :nil end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, _}, key) when key < k do
    lookup(left, key)
  end
  def lookup({:node, _, _, _, right}, key) do
    lookup(right, key)
  end



  # TO DELETE AN ELEMENT IN A TREE
  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do
  # ... = leftmost(right)
  # {:node, ..., ..., ..., ...}
  {key, value, rest} = leftmost(right)
  {:node, key, value, left, rest}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
  # {:node, k, v, ..., right}
  {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
  # {:node, k, v, left, ...}
  {:node, k, v, left, remove(right, key)}
  end
  def leftmost({:node, key, value, nil, rest}) do {key, value, rest} end
  def leftmost({:node, k, v, left, right}) do
  # ... = leftmost(left)
  # ...
  {key, value, rest} = leftmost(left)
  {key, value, {:node, k, v, rest, right}}
  end

end
