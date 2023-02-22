defmodule Higher do
  # Examples of higher order functions, map/2, reduce/2, filter/2 which exist
  # in the Enum module in elixir
  # higher order function: a function that takes another function as argument
  # advantages: simplicity in code, easy to understand the code at high level,
  # less time-consuming to write the code

  # map/2
  def apply_to_all([], _) do [] end
  def apply_to_all([h|t], func) do
   [func.(h)| apply_to_all(t, func)]
  end
  ###############################################

  def sum([]) do 0 end
  def sum([h|t]) do
    h + sum(t)
  end

  # difference between fold_right and fold_left
  # ex. add a list of elements [1,2,3,4]
  # fold_right: (1 + (2+ (3 + (4 + 0))))
  # fold_left: (4 + (3 + (2 + (1 + 0)))) (tail recursive)

  # reduce/2
  def fold_right([], acc, _ ) do acc end
  def fold_right([h|t], acc, f ) do
    f.(h, fold_right(t, acc, f))
  end

  def fold_left([], acc, _ ) do acc end
  def fold_left([h|t], acc, f ) do
  fold_left(t, f.(h, acc), f)
  end
  ##################################################

  def odd([]) do [] end
  def odd([h|t]) do
    if(rem(h,2)==1) do
      [h| odd(t)]
    else
      odd(t)
    end
  end


  # filter/2
  def filter([], _) do [] end
  def filter([h|t], f) do
    if(f.(h) == true) do
      [h| filter(t, f)]
    else
      filter(t, f)
    end
  end
  ############################################
end
