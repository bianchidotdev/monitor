defmodule Monitor.CheckReader do
  # TODO: other config
  # TODO: validate input
  def parse do
    path = Path.join(File.cwd!(), "etc/config.yaml")
    {:ok, config} = YamlElixir.read_from_file(path, atoms: true)
    {:ok, Enum.map(config["checks"], &parse_check(&1))}
  end

  defp parse_check(check_config) do
    Monitor.Check.new(check_config)
  end
end
