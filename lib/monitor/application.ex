defmodule Monitor.Application do
  use Application
  require Logger

  @moduledoc """
  Documentation for `Monitor`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Monitor.hello()
      :world

  """
  @impl true
  def start(_type, _args) do
    Logger.debug("Starting Application...")

    children = [
      {Registry, keys: :unique, name: Monitor.CheckRegistry},
      Monitor.CheckSupervisor,
      Monitor.CheckFactory
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Test.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# Start Dynamic supervisor - DynamicSupervisor, name: Monitor.CheckSupervisor
# Start check factory (uses CheckReader) -> creates workers under CheckSupervisor
