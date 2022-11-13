defmodule Monitor.CheckReader do
  # TODO: other config
  # TODO: validate input
  def read(path \\ "etc/config.yaml") do
    file = Path.join(File.cwd!(), path)
    {:ok, config} = YamlElixir.read_from_file(file, atoms: true)
    {:ok, Enum.map(config["checks"], &parse_check(&1))}
  end

  def read!(path \\ "etc/config.yaml") do
    case read(path) do
      {:ok, checks} ->
        checks

      {:error, reason} ->
        raise Monitor.Error, message: reason
    end
  end

  defp parse_check(check_config) do
    check = Monitor.Check.new(check_config)
    case Vex.valid?(check) do
      true -> check
      false -> raise Monitor.Error.CheckValidationError, message: inspect(Vex.errors(check))
    end

  end
end
