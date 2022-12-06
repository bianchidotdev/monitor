defmodule Monitor.CheckReader do
  # TODO: other config
  # TODO: validate input
  def read(path \\ "etc/config.yaml") do
    file = Path.join(File.cwd!(), path)
    {:ok, config} = YamlElixir.read_from_file(file, atoms: true)
    checks = Enum.map(config["checks"], &parse_check(&1))
    valid_checks = checks |> Enum.filter(&Vex.valid?/1)

    case valid_checks do
      [] -> {:error, checks |> Enum.map(&Vex.errors/1)}
      checks -> {:ok, checks}
    end
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

    case Vex.validate(check) do
      {:ok, check} -> check
      {:error, errors} -> raise Monitor.Error.CheckValidationError, message: inspect(errors)
    end
  end
end
