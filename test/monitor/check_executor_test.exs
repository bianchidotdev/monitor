defmodule Monitor.CheckExecutorTest do
  use ExUnit.Case
  doctest Monitor.CheckExecutor

  @mock_check Monitor.Check.new(%{
                type: "http",
                name: "fake test",
                http_config: %{
                  "host" => "httpstat.us",
                  "path" => "/200",
                  "scheme" => "https",
                  "method" => "get"
                }
              })

  test "it raises an error if the check type cannot be found" do
    check =
      Monitor.Check.new(%{
        type: "fake_type",
        name: "wrong type check",
        http_config: %{
          "host" => "httpstat.us",
          "path" => "/200",
          "scheme" => "https",
          "method" => "get"
        }
      })

    assert_raise Monitor.Error, fn -> Monitor.CheckExecutor.perform(check) end
  end

  test "it returns :ok and the response when successful" do
    # TODO(bianchi): mock successful call
    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, %{}}
  end

  test "it returns :ok with the error message and the response when unsuccessful" do
    # TODO(bianchi): mock error call
    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, "error message"}
  end

  test "it returns :ok with the error message in the case of a timeout" do
    # TODO(bianchi): mock timeout
    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, "error message"}
  end

  # TODO(bianchi): test side-effects - dropping events maybe?
end
