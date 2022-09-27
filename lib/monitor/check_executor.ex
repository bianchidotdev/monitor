defmodule Monitor.CheckExecutor do
  require Logger
  def perform(check) do
    {:ok, module} = Monitor.Check.module(check)
    case module.perform(check) do
      {:ok, resp} -> handle_success(check, resp)
      {:error, error} -> handle_failure(check, error)
    end
  end

  defp handle_success(check, resp) do
    # TODO
    Logger.info("Successfully ran #{check.name}")
    {:ok, resp}
  end

  defp handle_failure(check, error) do
    # TODO
    Logger.error("Failed running #{check.name} - error: #{error}")
    {:ok, error}
  end
end
