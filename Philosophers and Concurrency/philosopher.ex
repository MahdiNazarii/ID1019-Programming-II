defmodule Philosopher do

  @dreaming 300
  @eating 300
  @delay 200
  @timeout 1000

  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> init(hunger, strength, left, right, name, ctrl) end)
  end

  def init(hunger, strength, left, right, name, ctrl ) do
    gui = Gui.start(name)
    dreaming(hunger, strength, left, right, name, ctrl, gui)
  end

   # Philosopher is in a dreaming state.
  def dreaming(0, strength, _left, _right, name, ctrl, gui) do
    IO.puts("#{name} is full, strength is still #{strength}!\n")
    send(gui, :stop)
    send(ctrl, :done)
  end

  def dreaming(hunger, 0, _left, _right, name, ctrl, gui) do
    IO.puts("#{name} is starved to death, hunger is down to #{hunger}!\n")
    send(gui, :abort)
    send(ctrl, :done)
  end

  def dreaming(hunger, strength, left, right, name, ctrl, gui) do
    IO.puts("#{name} is dreaming!")
    send(gui, :leave)

    # sleep
    sleep(@dreaming)

    IO.puts("#{name} wakes up")
    waiting(hunger, strength, left, right, name, ctrl, gui)
  end

  #  # Philosopher is waiting for chopsticks.(without timeout)
  #  defp waiting(hunger, strength, left, right, name, ctrl, gui) do
  #   send(gui, :waiting)
  #   IO.puts("#{name} is waiting and needs to eat #{hunger} times !")

  #   case Chopstick.request(left) do
  #     :ok ->
	#       IO.puts("#{name} got left stick")

  #       sleep(@delay)

  #       case Chopstick.request(right) do
  #         :ok ->
  #           IO.puts("#{name} has both sticks!")
  #           eating(hunger, strength, left, right, name, ctrl, gui)
  #       end

  #   end
  # end

  #  # Philosopher is waiting for chopsticks.(with timeout)
  #  defp waiting(hunger, strength, left, right, name, ctrl, gui) do
  #   send(gui, :waiting)
  #   IO.puts("#{name} is waiting and needs to eat #{hunger} times !")

  #   case Chopstick.request(left, @timeout) do
  #     :ok ->
	#       IO.puts("#{name} got left stick")

  #       sleep(@delay)

  #       case Chopstick.request(right, @timeout) do
  #         :ok ->
  #           IO.puts("#{name} has both sticks!")
  #           eating(hunger, strength, left, right, name, ctrl, gui)
  #         :no ->
  #           IO.puts("#{name} has left stick but did not get the right, back to dream!")
  #           Chopstick.return(left)
  #           dreaming(hunger, strength-1, left, right, name, ctrl, gui)
  #       end
  #     :no ->
  #       IO.puts("#{name} did not get the left stick, back to dream!")
  #       dreaming(hunger, strength-1, left, right, name, ctrl, gui)
  #   end
  # end

  #  # Philosopher is waiting for chopsticks.(with timeout and ref)
  #  defp waiting(hunger, strength, left, right, name, ctrl, gui) do
  #   send(gui, :waiting)
  #   IO.puts("#{name} is waiting and needs to eat #{hunger} times !")

  #   # make a unique ref
  #   ref = make_ref()

  #   case Chopstick.request(left, ref, @timeout) do
  #     :ok ->
	#       IO.puts("#{name} got left stick")

  #       sleep(@delay)

  #       case Chopstick.request(right, ref, @timeout) do
  #         :ok ->
  #           IO.puts("#{name} has both sticks!")
  #           eating(hunger, strength, left, right, name, ctrl, gui, ref)
  #         :no ->
  #           IO.puts("#{name} has left stick but did not get the right, back to dream!")
  #           Chopstick.return(left, ref)
  #           dreaming(hunger, strength-1, left, right, name, ctrl, gui)
  #       end
  #     :no ->
  #       IO.puts("#{name} did not get the left stick, back to dream!")
  #       dreaming(hunger, strength-1, left, right, name, ctrl, gui)
  #   end
  # end

  # Philosopher is waiting for chopsticks (asynch send and synch receive)
  def waiting(hunger, strength, left, right, name, ctrl, gui) do
    IO.puts("#{name} is waiting, #{hunger} to go!")
    send(gui, :waiting)

    # make a unique ref
    ref = make_ref()

    # send requests for both chopsticks
    Chopstick.asynch(left, ref)
    Chopstick.asynch(right, ref)

    case Chopstick.synch(ref, @timeout) do
      :ok ->
	      IO.puts("#{name} got left stick")
        case Chopstick.synch(ref, @timeout) do
          :ok ->
            IO.puts("#{name} got both sticks!")
            eating(hunger, strength, left, right, name, ctrl, gui, ref)

          :no ->
            IO.puts("#{name} did not receive right sticks! Back to dreaming!")
            dreaming(hunger, strength-1, left, right, name, ctrl, gui)
        end
      :no ->
        IO.puts("#{name} did not receive left sticks! Back to dreaming!")
        dreaming(hunger, strength-1, left, right, name, ctrl, gui)
    end
  end

  # # Philosopher is eating.(chopstick without ref)
  # defp eating(hunger, strength, left, right, name, ctrl, gui) do
  #   send(gui, :enter)
  #   IO.puts("#{name} is eating...")

  #   sleep(@eating)

  #   Chopstick.return(left)
  #   Chopstick.return(right)

  #   dreaming(hunger - 1, strength, left, right, name, ctrl, gui)
  # end

  # Philosopher is eating (chopsticks with ref)
  def eating(hunger, strength, left, right, name, ctrl, gui, ref) do
    IO.puts("#{name} is eating...\n")
    send(gui, :enter)
    sleep(@eating)

    # return chopsticks
    Chopstick.return(left, ref)
    Chopstick.return(right, ref)

    dreaming(hunger - 1, strength, left, right, name, ctrl, gui)
  end

  def sleep(0), do: :ok
  def sleep(t), do: :timer.sleep(:rand.uniform(t))

end
