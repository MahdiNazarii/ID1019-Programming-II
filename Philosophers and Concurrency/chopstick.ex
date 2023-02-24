defmodule Chopstick do

  def start do
    stick = spawn_link(fn -> init() end)
    {:stick, stick}
  end

  def init() do
    # IO.puts("Chopsticks started")
    available()
  end

  # gone for chopsticks without ref
  defp gone() do
    receive do
      :return ->
            available()
      :quit ->
            :ok
    end
  end

  # available takes careof two types of chopsticks, with and without ref.
  def available() do
    receive do
      # used for chopsticks without ref
      {:request, from} ->
              send(from, :granted)
              gone()

      {:request, ref, from} ->
	            # used for chopsticks with ref
              send(from, {:granted, ref})
              gone(ref)

      :quit ->
              :ok
    end
  end

  # gone() with ref
  def gone(ref) do
    receive do
      {:return, ^ref} ->
	          available()
      :quit ->
            :ok
    end
  end

  def request({:stick, pid}) do
    send(pid, {:request, self()})
    receive do
      :granted ->
            :ok
    end
  end

   # Using a timeout to detect deadlock
  def request({:stick, pid}, timeout) when is_number(timeout) do
    send(pid, {:request, self()})
    receive do
      :granted ->
              :ok
    after
      timeout ->
              :no
    end
  end

  # using a tagged stick
  def request({:stick, pid}, ref, timeout) do
    send(pid, {:request, ref, self()})
    wait(ref, timeout)
  end

  defp wait(ref, timeout) do
    receive do
      {:granted, ^ref} ->
                :ok
      {:granted, _} ->
	              # this is an old answer to a requirement of chopstick
                wait(ref, timeout)
    after
      timeout ->
                :no
    end
  end


  # A asynchronous request, divided into sending the
  # request and waiting for the reply.
  def asynch({:stick, pid}, ref) do
    send(pid, {:request, ref, self()})
  end


  def synch(ref, timeout) do
    receive do
      {:granted, ^ref} ->
                  :ok
      {:granted, _} ->
	                ## this is an old message that we must ignore
                  synch(ref, timeout)
    after
      timeout ->
	                 :no
    end
  end

  def return({:stick, pid}) do
    send(pid, :return)
  end

   # Return a ref taged stick
  def return({:stick, pid}, ref) do
    send(pid, {:return, ref})
  end

  # To terminate the process.
  def quit({:stick, pid}) do
    send(pid, :quit)
  end
end
