defmodule Hanoi do

  def test() do
    IO.write("The list of moves: \n")
    hanoi(4, :a, :b, :c)
    IO.write("The number of moves: \n")
    length(hanoi(4, :a, :b, :c))
  end

  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1, from, to, aux) ++
    [{:move, from, to}] ++
    hanoi(n-1, aux, from, to)
  end
end
