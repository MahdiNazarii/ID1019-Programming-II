defmodule CalorieCounting do
  def greatest() do
    file = File.read!("/Users/mahdinazari/Documents/Programmering 2/Assignments/AdventOfCode_d1/caloriesList.txt")
    splited_outer = String.split(file, "\n\n")
    splited_inner = Enum.map(splited_outer, fn(x) -> String.split(x, "\n") end)
    convertToInt= Enum.map(splited_inner, fn(seq) -> Enum.map(seq, fn(x) ->
      {i, _} = Integer.parse(x)
      i
    end)
  end)
  sumOfElem = Enum.map(convertToInt, fn(list) -> Enum.reduce(list, 0, fn x, acc -> x + acc end) end)
  sumOfElem |> Enum.reduce(&max/2)
  sortedList = Enum.reverse(Enum.sort(sumOfElem))
 # greatest = sortedList |> Enum.take(1)
  totalCalories = Enum.sum(Enum.take(sortedList, 3))

  end



  def test2() do
    #[5, 8, 4, 6, 10, 5] |> Enum.reduce(&max/2)
  end

end
