defmodule Mix.Tasks.Monitor.Server do
  use Mix.Task

  @shortdoc "Starts applications and their servers"

  @moduledoc """
  Starts the application
  ## Command line options
  Furthermore, this task accepts the same command-line options as
  `mix run`.
  For example, to run `monitor.server` without recompiling:
      $ mix monitor.server --no-compile
  The `--no-halt` flag is automatically added.
  """

  @impl true
  def run(args) do
    Application.put_env(:monitor, :server, true, persistent: true)
    Mix.Tasks.Run.run(args ++ run_args())
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end
end
