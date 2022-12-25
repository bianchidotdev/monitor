defmodule Monitor.CheckFactory do
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init(_arg) do
    {:ok, checks} = Monitor.CheckReader.read()
    Enum.each(checks, &Monitor.CheckSupervisor.start_child/1)
    {:ok, self()}
  end
end
