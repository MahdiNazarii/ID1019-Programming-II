defmodule Exercise do

  def double( [] ) do [] end
  def double( [h|t] ) do
  [h*2 | double(t)]
  end

  def five([]) do [] end
  def five([h|t]) do
    [h+5 | five(t)]
  end

  def animal([]) do [] end
  def animal([h|t])  do
    if(h == :dog) do
      [:fido | animal(t)]
    else
      [h| animal(t)]
    end
end


  def double_five_animal([], _) do [] end
  def double_five_animal( [h|t], op) do
    case op do
      :double -> [h*2 | double_five_animal(t, op)]
      :five ->  [h + 5 | double_five_animal(t, op)]
      :animal -> if(h == :dog) do
        [:fido | double_five_animal(t, op)]
      else
        [h | double_five_animal(t, op)]
      end
    end
  end



end
