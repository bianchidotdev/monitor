defmodule Monitor.Check do
  @enforce_keys [:name, :type, :frequency]
  defstruct [:name, :type, :frequency, :shell_config, :http_config]
  use ExConstructor

  @callback run(any) :: {:ok, term} | {:error, String.t}

  @type_to_module %{
    "http" => Monitor.Check.HttpCheck,
    "shell" => Monitor.Check.ShellCheck
  }

  def module(check) do
    case @type_to_module[check.type] do
      nil -> {:error, :unsupported_type}
      type -> {:ok, type}
    end
  end
end
