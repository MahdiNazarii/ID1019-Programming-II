defmodule Morse do
  defp my_name(), do: 'mahdi nazari cinte2'
  defp base(), do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
  defp rolled(), do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '

  # create an encode_table as a tuple to have an O(1) lookup operation
  defp encode_table(tree) do
    codes = Enum.sort(codes(tree, []), fn({x,_},{y,_}) -> x < y end)
    lst = list(codes,0)
    List.to_tuple(lst)
  end

  defp list([], _), do: []
  defp list([{n, code} | codes], n), do: [code | list(codes, n + 1)]
  defp list(codes, n), do: [:na | list(codes, n + 1)]

  # an O(1) lookup operation
  defp lookup(char, table), do: elem(table, char)

  # go throw Morse txxree and make a list of tree's chars
  defp codes(nil, _), do: []
  defp codes({:node, :na, a, b}, code) do
    left_branch = codes(a, code++[?-])
    right_branch = codes(b, code++[?.])
    left_branch ++ right_branch
  end
  defp codes({:node, char, nil, nil}, code) do
    [{char, code}]
  end
  defp codes({:node, char, a, nil}, code) do
    [{char, code}] ++ codes(a, code)
  end
  defp codes({:node, char, nil, b}, code) do
    [{char, code}] ++ codes(b,code)
  end
  defp codes({:node, char, a, b}, code) do
    left_branch = codes(a, code++[?-])
    right_branch = codes(b, code++[?.])
    [{char, code}] ++ left_branch ++ right_branch
  end

  # wonder if the solution is tail recursive
  def encoder(text) do
    table = encode_table(morse())
    encode(text, table, [])
  end

  defp encode([], _, acc), do: rev_flat(acc)
  defp encode([char | rest], table, acc) do
    code = lookup(char, table)
    encode(rest, table, [code | acc])
  end

  # To reverse and flatten a list
  defp rev_flat(lst) do rev_flat(lst, []) end
  defp rev_flat([], rev) do rev end
  defp rev_flat([h|t], rev) do rev_flat(t, h ++ [?\s |rev]) end

  # decode part
  def decoder(signal) do
    table = decode_table()
    decode(signal, table, [],table)
  end

  # decode table is the Morse tree
  defp decode_table() do morse() end


  defp decode([], {:node, char, _, _}, acc, _)  do
    [char |acc]
  end
  defp decode([?- | seq], {:node, :na,left, _}, acc, table) do
    decode(seq, left, acc, table)
  end
  defp decode([?. | seq], {:node, :na, _, right}, acc, table) do
    decode(seq, right, acc, table)
  end
  defp decode([?- | seq], {:node, _,left, _}, acc, table) do
    decode(seq, left, acc, table)
  end
  defp decode([?. | seq], {:node, _, _, right}, acc, table) do
    decode(seq, right, acc, table)
  end
  defp decode([?\s], {:node, char, _, _}, acc, _) do reverse([char|acc]) end
  defp decode([?\s | seq], {:node, char, _, _}, acc, table) do
    decode(seq, table, [char | acc],table)
  end

  def reverse(lst) do reverse(lst, []) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

  # to demonstrate that encoder and decoder functions perform correctly
  def demo() do
    text = my_name()
    enc_name = encoder(text)

    signal1 = base()
    signal2 = rolled()
    dec_sig1 = decoder(signal1)
    dec_sig2 = decoder(signal2)

    IO.puts("#{inspect(text)} encoded to: #{inspect(enc_name)}\n")
    IO.puts("Signal 'base' decoded to: #{inspect(dec_sig1)}")
    IO.puts("Signal 'rolled' decoded to: #{inspect(dec_sig2)}\n")
  end

  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
end
