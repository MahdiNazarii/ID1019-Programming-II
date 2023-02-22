defmodule Carlo do

  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    :math.pow(r, 2) > (:math.pow(x, 2) + :math.pow(y, 2))
  end

  def round(0, _, a) do a end
  def round(k, r, a) do
    if dart(r) do
      round(k-1, r, a+1)
    else
      round(k-1, r, a)
    end
  end

  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end
  def rounds(0, _, t, _, a) do 4*a/t end
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    pi = 4*a/t
    :io.format("Generated pi = ~20.15f,  Difference = ~20.15f\n", [pi, (pi - :math.pi())])
    #:io.format(" t = ~12w, pi = ~14.10f,  dp = ~14.10f, da = ~8.4f,  dz = ~12.8f\n", [t, pi,  (pi - :math.pi()), (pi - 22/7), (pi - 355/113)])
    rounds(k-1, 2*j, t, r, a)
  end


  def leibniz(n) do
    4 * Enum.reduce(0..n, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
  end

end
