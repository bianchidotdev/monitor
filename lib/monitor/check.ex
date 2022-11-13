defmodule Monitor.Check do
  @enforce_keys [:name, :type, :frequency]
  defstruct [:name, :type, :frequency, :shell_config, :http_config]
  use ExConstructor
  use Vex.Struct
  # TODO(bianchi): better validations
  validates :name, presence: true
  validates :type, presence: true
  validates :frequency, presence: true

  @callback run(any) :: {:ok, term} | {:error, String.t()}

  @type_to_module %{
    "http" => Monitor.Check.HttpCheck,
    "shell" => Monitor.Check.ShellCheck
  }

  def execution_module(check) do
    case @type_to_module[check.type] do
      nil -> {:error, :unsupported_type}
      type -> {:ok, type}
    end
  end
end
