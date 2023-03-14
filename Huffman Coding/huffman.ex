defmodule Huffman do
  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text do
    'this is something that we should encode'
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    # To implement...
    #IO.puts("Sample: #{sample}")
    freq = freq(sample)
    #sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    sorted = List.keysort(freq, 1)
    #IO.puts("Sorted: #{inspect(sorted)}")
    huffman_tree(sorted)
  end

  # Build the actual Huffman tree
  def huffman_tree([{tree, _}]), do: tree
  def huffman_tree([{char1, frq1}, {char2, frq2} | rest]) do
    # combine two elements with lowest freq into a new node and insert it to the seq
    huffman_tree(sort({{char1, char2}, frq1 + frq2}, rest))
  end

  # to insert the new node into the seq and keep the seq sorted
  def sort({char, frq}, []), do: [{char, frq}]
  def sort({char1, frq1}, [{char2, frq2} | rest]) do
    if frq1 < frq2 do
      [{char1, frq1}, {char2, frq2} | rest]
    else
      [{char2, frq2} | sort({char1, frq1}, rest)]
    end
  end


  # to count the frequency of each character
  def freq(sample) do
    freq(sample,[])
  end
  # pattern matching converts a string to its respective utf8 value
  def freq([], freq) do freq end
  def freq([char | rest], freq) do
    freq(rest, count(char, freq))
  end

  def count(char, []) do [{char, 1}] end
  def count(char, [{char,n}|rest]) do
    [{char, n+1}|rest]
  end
  def count(char, [head|rest]) do
    [head|count(char, rest)]
  end

  # to make a encode_table for each char by its path in the tree
  def encode_table(tree) do
    # To implement...
    Enum.sort(codes(tree, []), fn({_,x},{_,y}) -> length(x) < length(y) end)
    #List.keysort(codes(tree, []), 1)
    #codes(tree, [])
  end

  def codes({a, b}, path) do
    left_branch = codes(a, path++[0])
    right_branch = codes(b, path++[1])
    left_branch ++ right_branch
  end
  def codes(a, code) do
    [{a, code}]
  end


  def encode([], _), do: []
  def encode([char | rest], table) do
    # To implement...
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end

  # decode_table is the same as encode_table above
  # def decode_table(tree) do
  #   # To implement...
  #   #codes(tree, [])
  #   Enum.sort(codes(tree, []), fn({_,x},{_,y}) -> length(x) < length(y) end)
  # end

  # # Given in the assignment
  # def decode([], _) do [] end
  # def decode(seq, table) do
  #   # To implement...
  #   {char, rest} = decode_char(seq, 1, table)
  #   [char | decode(rest, table)]
  # end
  # def decode_char(seq, n, table) do
  #   {code, rest} = Enum.split(seq, n)
  #   case List.keyfind(table, code, 1) do
  #     {char, _} ->
  #             {char, rest}
  #     nil ->
  #             decode_char(seq, n+1, table)
  #   end
  # end

  # A more officient decode method
  def decode_table(tree) do tree end

  def decode(seq, tree) do
    decode(seq, tree, tree)
  end

  def decode([], char, _)  do
    [char]
  end
  def decode([0 | seq], {left, _}, tree) do
    decode(seq, left, tree)
  end
  def decode([1 | seq], {_, right}, tree) do
    decode(seq, right, tree)
  end
  def decode(seq, char, tree) do
    [char | decode(seq, tree, tree)]
  end

 # read the whole file and return a list of chars
  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
     binary = IO.read(file, :all)
     File.close(file)
     #IO.puts("Binary:\n #{binary}")
     case :unicode.characters_to_list(binary, :utf8) do
       {:incomplete, list, _} ->
              list
       list ->
              list
     end
   end

  # Benchmark section
  #  def bench(file) do
  #   text = read(file)
  #   #text = String.to_charlist(sample())
  #   c = length(text)
  #   {t2, tree} = :timer.tc(fn -> tree(text) end)
  #   {t3, encodeTable} = :timer.tc(fn -> encode_table(tree) end)
  #   s = length(encodeTable)
  #   {_, decodeTable} = :timer.tc(fn -> decode_table(tree) end)
  #   {t5, encoded} = :timer.tc(fn -> encode(text, encodeTable) end)
  #   e = div(length(encoded), 8) # byte size of encoded data
  #   r = Float.round(e / byte_size("#{text}"), 3) # the ratio of the orginal data vs encoded data
  #   {t6, decoded} = :timer.tc(fn -> decode(encoded, decodeTable) end)

  #   #IO.puts("text:\n #{inspect(text)}")
  #   IO.puts("Tree: #{inspect(tree)}\n")
  #   IO.puts("encode : #{inspect(encodeTable)}\n")
  #   #IO.puts("decode: #{inspect(decodeTable)}\n")
  #   IO.puts("encoded: #{inspect(encoded)}\n")
  #   IO.puts("decoded: #{inspect(decoded)}\n")
  #   #IO.puts("String: #{List.to_string(decoded)}\n")
  #   IO.puts("text of #{c} characters")
  #   IO.puts("tree built in #{t2/1000} ms")
  #   IO.puts("table of size #{s} in #{t3/1000} ms")
  #   IO.puts("encoded in #{t5/1000} ms")
  #   IO.puts("decoded in #{t6/1000} ms")
  #   IO.puts("source #{ byte_size("#{text}")} bytes, encoded to #{e} bytes, compression rate: #{r}")
  # end
  def benchMark(file) do
    text = read(file)
    size = byte_size("#{text}")
    c = length(text)
    tree = tree(text)
    encodeTable = encode_table(tree)
    decodeTable = decode_table(tree)
    number_chars = length(encodeTable)
    {t1, encoded} = :timer.tc(fn -> encode(text, encodeTable) end)
    encodedSize = div(length(encoded), 8)
    rate = Float.round((encodedSize / size), 3)
    {t2, decoded} = :timer.tc(fn -> decode(encoded, decodeTable) end)

    # IO.puts("Tree: #{inspect(tree)}\n")
    # IO.puts("Encode_table : #{inspect(encodeTable)}\n")
    # IO.puts("Encoded data: #{inspect(encoded)}\n")
    # IO.puts("Decoded data: #{inspect(decoded)}\n")
    IO.puts("Text of #{c} characters, and size is #{size} bytes.")
    IO.puts("Number of chars: #{number_chars}")
    IO.puts("Encoded in #{t1/1000} ms")
    IO.puts("Decoded in #{t2/1000} ms")
    IO.puts("Encoded data is #{encodedSize} bytes, compression rate: #{rate}")
  end


end
