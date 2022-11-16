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

  test "it is not valid when it is missing config" do
    assert Vex.valid?(%Monitor.Check{type: nil, name: nil, frequency: nil}) == false
  end
end
