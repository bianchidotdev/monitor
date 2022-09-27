defmodule Monitor.MixProject do
  use Mix.Project

  def project do
    [
      app: :monitor,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Monitor.Application, []},
      applications: [:httpoison],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exconstructor, "~> 1.2"},
      {:httpoison, "~> 1.8"},
      {:yaml_elixir, "~> 2.9"}
    ]
  end
end
