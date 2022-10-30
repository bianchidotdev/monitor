defmodule Monitor.Check.HttpCheck do
  @behaviour Monitor.Check
  use Monitor.InstrumentationHelper

  @method_map %{
    "get" => :get,
    "post" => :post,
    "put" => :put,
    "head" => :head,
    "delete" => :delete
  }

  def run(check) do
    %{"host" => host, "scheme" => scheme, "method" => method_string, "path" => path} =
      check.http_config

    url = scheme <> "://" <> host <> path
    method = @method_map[String.downcase(method_string)]
    handle_resp(HTTPoison.request(method, url))
  end

  defp handle_resp({:ok, %HTTPoison.Response{status_code: status, body: body}}) do
    case status do
      x when x in 200..299 -> {:ok, body}
      _ -> {:error, body}
    end
  end

  defp handle_resp({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
