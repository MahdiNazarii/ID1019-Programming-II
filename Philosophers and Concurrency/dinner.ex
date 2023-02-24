defmodule Dinner do
  # a benchmark with different number of hunger
  def bench() do
    seq = [10, 50, 100, 150, 200]
    Enum.each(seq, fn(e) -> start(e) end)
  end

  def start(n) do
    # start the timer
    start = System.os_time(:second)
    spawn(fn -> init(n, start) end)
  end

  def init(hunger, start) do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    ctrl = self()
    Philosopher.start(hunger, 5, c1, c2, "Arendt", ctrl)
    Philosopher.start(hunger, 5, c2, c3, "Hypatia", ctrl)
    Philosopher.start(hunger, 5, c3, c4, "Simone", ctrl)
    Philosopher.start(hunger, 5, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(hunger, 5, c5, c1, "Ayn", ctrl)

    wait(5, [c1, c2, c3, c4, c5])
    # The dinner is eaten, return the time that dinner was going on
    IO.puts("The dinner for #{hunger} hunger is completed in: #{System.os_time(:second) - start} s")
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end

  def wait(n, chopsticks) do
    receive do
    :done ->
          wait(n-1, chopsticks)
    :abort ->
          :io.format("dinner aborted\n")
          Process.exit(self(), :kill)
    end
  end
end
