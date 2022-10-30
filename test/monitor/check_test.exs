defmodule Monitor.CheckTest do
  use ExUnit.Case
  doctest Monitor.Check

  @mock_check_config %{
    type: "http",
    name: "fake test",
    frequency: "10",
    http_config: %{
      "host" => "httpstat.us",
      "path" => "/200",
      "scheme" => "https",
      "method" => "get"
    }
  }

  test "it successfully creates a check with valid config" do
    assert Monitor.Check.new(@mock_check_config) == %Monitor.Check{
      type: "http",
      name: "fake test",
      frequency: "10",
      http_config: %{
        "host" => "httpstat.us",
        "path" => "/200",
        "scheme" => "https",
        "method" => "get"
      }
    }
  end

  test "it returns an argument error when missing required config" do
    # TODO(bianchi): make raise error on missing args - or maybe different behavior
    assert_raise ArgumentError, "", fn -> Monitor.Check.new(%{}) end
  end
end
