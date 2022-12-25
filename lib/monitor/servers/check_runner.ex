require Logger

defmodule Monitor.CheckRunner do
  use GenServer

  def child_spec(check) do
    %{
      id: check.name,
      start: {__MODULE__, :start_link, [check]}
    }
  end

  def start_link(check) do
    GenServer.start_link(__MODULE__, check, name: process_name(check))
  end

  @impl true
  def init(check) do
    :timer.send_interval(check.frequency * 1000, :perform)
    {:ok, check}
  end

  @impl true
  def handle_info(:perform, check) do
    {:ok, result} = Monitor.CheckExecutor.perform(check)

    {:ok, check} =
      case result do
        %{status: :success, message: message} -> handle_success(check, message)
        %{status: :failure, error: error} -> handle_failure(check, error)
      end

    results = LimitedQueue.push(check.results, result)
    check = %{check | results: results}
    {:noreply, check}
  end

  defp process_name(check) do
    {:via, Registry, {Monitor.CheckRegistry, "#{check.name}"}}
  end

  # If the current state of the check is healthy, this will just log.
  # Otherwise, it will drop a recovery event.
  defp handle_success(%Monitor.Check{state: :healthy} = check, _resp) do
    Logger.info("Successfully ran #{check.name}")
    {:ok, check}
  end

  defp handle_success(%Monitor.Check{state: :unhealthy} = check, _resp) do
    Logger.info("#{check.name} recovered from unhealthy state")
    check = %{check | state: :healthy}
    # TODO: drop recovery event
    {:ok, check}
  end

  # If the current state of a check is healthy, this will drop a regression event.
  # Otherwise, it will just log. Theoretically, this could retrigger an alert after
  # a fixed period of time or failure events.
  defp handle_failure(%Monitor.Check{state: :healthy} = check, error) do
    Logger.warn("#{check.name} fell into unhealthy state- error: #{error}")
    check = %{check | state: :unhealthy}
    # TODO: drop regression event
    {:ok, check}
  end

  defp handle_failure(%Monitor.Check{state: :unhealthy} = check, error) do
    Logger.warn("Failed running #{check.name} - error: #{error}")
    {:ok, check}
  end
end
