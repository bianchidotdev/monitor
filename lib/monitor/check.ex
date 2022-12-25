defmodule Monitor.Check do
  @enforce_keys [:name, :type, :frequency]
  defstruct [
    :name,
    :type,
    :frequency,
    :config,
    state: :healthy,
    results: LimitedQueue.new(5, :drop_oldest)
  ]

  use ExConstructor
  use Vex.Struct
  # TODO(bianchi): validations on config
  validates(:name, presence: true)
  validates(:type, presence: true)
  validates(:frequency, presence: true)
  validates(:state, inclusion: [:healthy, :unhealthy])

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
