defmodule Moves do
  def single({_, 0}, state) do state end
  def single({:one, n}, {main, one, two}) do
    if(n > 0) do
      {0,remain, take} = Train.main(main, n)
      {remain, take, two}
    else if(n < 0) do
      wagons = Train.take(one, -n)
      {Train.append(main, wagons), Train.drop(one, -n), two}
    end
    end
  end
  def single({:two, n}, {main, one, two}) do
    if(n > 0) do
      {0,remain, take} = Train.main(main, n)
      {remain, one, take}
    else if(n < 0) do
      wagons = Train.take(two, -n)
      {Train.append(main, wagons), one, Train.drop(two, -n)}
    end
    end
  end

  def sequence([], state) do state end
  def sequence([h|t], state) do
    [state | sequence(t, single(h, state))]
  end

end
