defmodule Monitor.Check.ShellCheck do
  @behaviour Monitor.Check
  use Monitor.InstrumentationHelper

  def run(check) do
    %{"command" => command, "args" => args} = check.shell_config

    try do
      {response, exit_code} = System.cmd(command, args, stderr_to_stdout: true)
      handle_resp(exit_code, response)
    rescue
      e -> handle_error(e)
    end
  end

  defp handle_resp(0, response) do
    {:ok, response}
  end

  defp handle_resp(exit_code, response) do
    error_message = Enum.join(Enum.reject([exit_code, response], &is_nil/1), ": ")
    {:error, error_message}
  end

  defp handle_error(error) do
    error_type = error.__struct__
    %{original: original, reason: reason} = error
    error_message = Enum.join(Enum.reject([original, reason], &is_nil/1), " ")
    {:error, "(#{error_type}) #{error_message}"}
  end
end
