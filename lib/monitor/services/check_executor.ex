defmodule Monitor.CheckExecutor do
  @moduledoc """
    Executes arbitrary check types - If the check runs successfully, even if it
    fails, we return an {:ok, message} from this module because we count the check as completed.
    Actual errors will result in an {:error, error} response
  """
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
    Logger.warn("Failed running #{check.name} - error: #{error}")
    {:ok, error}
  end
end
