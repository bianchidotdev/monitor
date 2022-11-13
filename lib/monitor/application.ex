defmodule Monitor.Application do
  use Application
  require Logger

  @moduledoc """
  Documentation for `Monitor`.
  """

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Monitor.CheckRegistry},
    ] ++ server_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Test.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp server_children do
    if server?() do
      Logger.info("Starting server")
      [
        Monitor.CheckSupervisor,
        Monitor.CheckFactory
      ]
    else
      []
    end
  end

  defp server? do
    Application.get_env(:monitor, :server, false)
  end
end

# Start Dynamic supervisor - DynamicSupervisor, name: Monitor.CheckSupervisor
# Start check factory (uses CheckReader) -> creates workers under CheckSupervisor

# Ideas
# maybe implement the check execution as a queue instead of using the :timer.send_interval
# maybe file all results to ETS, and trigger an event when there's a failure
  # how handle recoveries?
  # Add in check state to check struct or ETS
