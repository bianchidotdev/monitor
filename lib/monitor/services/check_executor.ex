defmodule Monitor.CheckExecutor do
  @moduledoc """
    Executes arbitrary check types - If the check runs successfully, even if it
    fails, we return an `{:ok, {status: :success/:failure, message: message}}` from
    this module because we count the check as completed.
    Actual errors will result in an {:error, error} response
  """

  def perform(check) do
    case Monitor.Check.execution_module(check) do
      {:ok, module} ->
        case module.perform(check) do
          {:ok, resp} -> {:ok, %{status: :success, message: resp}}
          {:error, error} -> {:ok, %{status: :failure, error: error}}
        end

      {:error, error} ->
        raise Monitor.Error, message: error
    end
  end
end
