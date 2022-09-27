defmodule Monitor.Scheduler do
  use GenServer

  def child_spec(check) do
    %{
      id: check.name,
      start: {__MODULE__, :start_link, [check]}
    }
  end

  def start_link(check) do
    GenServer.start_link(__MODULE__, check, name: String.to_atom(check.name))
  end

  @impl true
  def init(check) do
    :timer.send_interval(check.frequency * 1000, :perform)
    {:ok, check}
  end

  @impl true
  def handle_info(:perform, check) do
    perform(check)
    {:noreply, check}
  end

  defp perform(check) do
    {:ok, _res} = Monitor.CheckExecutor.perform(check)
    check
  end
end
