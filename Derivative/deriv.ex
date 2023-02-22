defmodule Deriv do

  @type literals() :: {:num, number()} | {:var, atom()}

  @type expr() :: literals()
  | {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literals()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:sq_root, expr()}
  | {:sin, expr()}
  | {:cos, expr()}

  def test1() do
    # e = {:add,
    #     {:mul, {:num, 2}, {:var, :x}},
    #     {:mul, {:num, 6}, {:var, :x}}
    #     }
    e ={:add,
        {:num, 2},
        {:num, 6}
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test2() do
    e = {:add,
        {:exp, {:mul, {:num, 2},{:var, :x}}, {:num, 6}},
        {:num, 4}
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(simplify(d)))}\n")
    :ok
  end

  def test3() do
    e = {:ln,
        {:mul, {:num, 5},
        {:exp, {:var, :x}, {:num, 2}}}
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def test4() do
    e = {:div,
        {:var, :x},
        {:mul, {:num, 5}, {:var, :x}}
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end
  def test5() do
    e = {:sq_root,
        {:mul,
        {:num, 5},
        {:var, :x}
        }
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end
  def test6() do
    e = {:sin,
        {:mul,
        {:num, 5},
        {:var, :x}
        }
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end
  def test7() do
    e = {:cos,
        {:mul,
        {:num, 5},
        {:var, :x}
        }
        }
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
    {:mul, deriv(e1, v), e2},
    {:mul, e1, deriv(e2, v)}
    }
  end
  def deriv({:exp, e1, {:num, n}}, v) do
  {:mul,
  deriv(e1, v),
  {:mul, {:num, n}, {:exp, e1, {:num, n-1}}}
  }
  end
  def deriv({:ln, e}, v) do
    {:div, deriv(e, v), e}
  end
  def deriv({:div, e1, e2}, v) do
    {:div,
    {:sub,
    {:mul, deriv(e1, v), e2},
    {:mul, e1, deriv(e2, v)}
    },
    {:mul, e2, e2}
    }
  end
  def deriv({:sq_root, e}, v) do
    {:div,
    deriv(e, v),
    {:mul, {:num, 2}, {:sq_root, e}}
    }
  end
  def deriv({:sin, e}, v) do
    {:mul,
    deriv(e, v),
    {:cos, e}
    }
  end
  def deriv({:cos, e}, v) do
    {:mul,
    {:num, -1},
      {:mul,
      deriv(e, v),
      {:sin, e}}
    }
  end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, n}) do "#{n}" end
  def pprint({:mul, {:var, n}, {:var, n}}) do "#{n} ^ 2" end
  def pprint({:mul, {:mul, {:num, n}, {:var, v}}, {:mul, {:num, n}, {:var, v}}}) do "(#{n} * #{v}) ^ 2" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:sub, e1, e2}) do "(#{pprint(e1)} - #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)}) ^ (#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln #{pprint(e)}" end
  def pprint({:div, e1, e2}) do "#{pprint(e1)} / #{pprint(e2)}" end
  def pprint({:sq_root, e}) do "√ (#{pprint(e)})" end
  def pprint({:sin, e}) do "sin (#{pprint(e)})" end
  def pprint({:cos, e}) do "cos (#{pprint(e)})" end
  def pprint(:sin) do "sin" end
  def pprint(:cos) do "cos" end





  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:sub, e1, e2}) do
    simplify_sub(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_sub(e1, {:num, 0}) do e1 end
  def simplify_sub({:num, n1}, {:num, n2}) do {:num, n1 - n2} end
  def simplify_sub({:mul, {:num, n}, {:var, :v}}, {:mul, {:var, :v}, {:num, n}}) do {:num, 0} end
  def simplify_sub(e1, e2) do {:sub, e1, e2} end


  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, {:var, :x}}) do {:mul, {:num, n1 * n2}, {:var, :x}} end
  def simplify_mul({:num, n1}, {:mul, e1, {:num, 1}}) do {:mul, n1, e1} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e1}) do {:mul, {:num, n1 * n2}, e1} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(e, {:num, 1}) do e end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1 / n2} end
  def simplify_div(e1, e2) do {:div, e1, e2} end




#########################################################
 def fib(0) do 0 end
 def fib(1) do 1 end
 def fib(n) do
  fib(n-1) + fib(n-2)
 end
#########################################################
end
