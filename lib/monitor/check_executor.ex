defmodule Monitor.CheckExecutor do
  require Logger

  def perform(check) do
    case Monitor.Check.execution_module(check) do
      {:ok, module} ->
        case module.perform(check) do
          {:ok, resp} -> handle_success(check, resp)
          {:error, error} -> handle_failure(check, error)
        end

      {:error, error} ->
        raise Monitor.Error, message: error
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
