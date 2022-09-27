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
    {:ok, checks} = Monitor.ConfigReader.parse
    check_servers = Enum.map(checks, &Monitor.Scheduler.child_spec/1)
    children = check_servers ++ [
      # Starts a worker by calling: Test.Worker.start_link(arg)
      # {Test.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Test.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
