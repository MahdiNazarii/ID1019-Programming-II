defmodule Expression do
  @type literals() :: {:num, number()} | {:var, atom()} | {:q, {:num, number()}, {:num, number()}}

  @type expr() :: literals()
  | {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}

  def test() do
    env = new_env()
    env = env_add({:var, :x}, {:num, 4}, env)
    env = env_add({:var, :y}, {:num, 5}, env)

    expr = {:div, {:q, {:num, 20}, {:var, :y}}, {:q, {:num, 2}, {:var, :x}}}
    eval(expr, env)
  end

  def new_env() do Map.new() end
  def env_add(v, n , env) do
    Map.put(env, v, n)
  end

  def eval({:num, n}, _) do {:num, n} end
  def eval({:q, {:num, n}, {:num, m}}, _) do {:q, {:num, n}, {:num, m}} end
  def eval({:q, {:num, n}, {:var, v}}, env) do {:q, {:num, n}, eval({:var, v}, env)} end
  def eval({:q, {:var, v}, {:num, n}}, env) do {:q, eval({:var, v}, env), {:num, n}} end
  def eval({:q, {:var, v}, {:var, v1}}, env) do {:q, eval({:var, v}, env), eval({:var, v1}, env)} end
  def eval({:var, v}, env) do Map.get(env, {:var, v}) end
  def eval({:add, e1, e2}, env) do
    add(eval(e1, env), eval(e2, env))
  end
  def eval({:sub, e1, e2}, env) do
    sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    mul(eval(e1, env), eval(e2, env))
  end
  def eval({:div, e1, e2}, env) do
    divi(eval(e1, env), eval(e2, env))
  end

  def add({:num, 0}, e2) do e2 end
  def add(e1, {:num, 0}) do e1 end
  def add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def add({:q, {:num, n}, {:num, m}}, {:num, n1}) do {:q, add(mul({:num, n1}, {:num, m}), {:num, n}), {:num, m}} end
  def add({:num, n1}, {:q, {:num, n}, {:num, m}}) do {:q, add(mul({:num, n1}, {:num, m}), {:num, n}), {:num, m}} end
  def add({:q, {:num, n}, {:num, m}}, {:q, {:num, n1}, {:num, m1}}) do divi(add(mul({:num, n}, {:num, m1}), mul({:num, n1}, {:num, m})), mul({:num, m}, {:num, m1})) end
  def add(e1, e2) do {:add, e1, e2} end

  def sub(e1, {:num, 0}) do e1 end
  def sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end
  def sub({:mul, {:num, n}, {:var, :v}}, {:mul, {:var, :v}, {:num, n}}) do {:num, 0} end
  def sub({:q, {:num, n}, {:num, m}}, {:num, n1}) do {:q, sub({:num, n}, mul({:num, n1}, {:num, m})), {:num, m}} end
  def sub({:num, n1}, {:q, {:num, n}, {:num, m}}) do {:q, sub(mul({:num, n1}, {:num, m}), {:num, n}), {:num, m}} end
  def sub({:q, {:num, n}, {:num, m}}, {:q, {:num, n1}, {:num, m1}}) do divi(sub(mul({:num, n}, {:num, m1}), mul({:num, n1}, {:num, m})), mul({:num, m}, {:num, m1})) end
  def sub(e1, e2) do {:sub, e1, e2} end

  def mul({:num, 0}, _) do {:num, 0} end
  def mul(_, {:num, 0}) do {:num, 0} end
  def mul({:num, 1}, e2) do e2 end
  def mul(e1, {:num, 1}) do e1 end
  def mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def mul({:num, n1}, {:mul, {:num, n2}, {:var, :x}}) do {:mul, {:num, n1 * n2}, {:var, :x}} end
  def mul({:num, n1}, {:mul, e1, {:num, 1}}) do {:mul, n1, e1} end
  def mul({:num, n1}, {:mul, {:num, n2}, e1}) do {:mul, {:num, n1 * n2}, e1} end
  #
  def mul({:q, {:num, n}, {:num, m}}, {:num, n1}) do divi({:num, n1*n}, {:num, m}) end
  def mul({:num, n1}, {:q, {:num, n}, {:num, m}}) do divi({:num, n1*n}, {:num, m}) end
  def mul({:q, {:num, n}, {:num, m}}, {:q, {:num, n1}, {:num, m1}}) do divi({:num, n*n1}, {:num, m*m1}) end
  #
  def mul(e1, e2) do {:mul, e1, e2} end


  def divi(_, {:num, 0}) do IO.puts("Oops! Division by zero!") end
  def divi({:num, 0}, _) do {:num, 0} end
  def divi(e, {:num, 1}) do e end
  def divi({:q, {:num, n}, {:num, m}}, {:num, n1}) do divi({:num, n}, {:num, n1*m}) end
  def divi({:num, n1}, {:q, {:num, n}, {:num, m}}) do divi({:num, n1*m}, {:num, n}) end
  def divi({:q, {:num, n}, {:num, m}}, {:q, {:num, n1}, {:num, m1}}) do divi({:num, n*m1}, {:num, m*n1}) end
  def divi({:num, n1}, {:num, n2}) do
    if rem(n1, n2) == 0 do
      {:num, n1 / n2}
    else
      {:q, divi({:num, n1} , gcd(n1, n2)) , divi({:num, n2} , gcd(n1, n2))}
   end
  end

  def gcd(x, 0) do {:num, x} end
  def gcd(x, y) do gcd(y, rem(x,y)) end

end
