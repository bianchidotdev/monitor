defmodule Monitor.CheckReaderTest do
  use ExUnit.Case, async: true

  setup do
    [
      test_check: %Monitor.Check{
        frequency: 60,
        http_config: %{"host" => "httpstat.us", "method" => "get", "path" => "/200", "scheme" => "https"},
        name: "fake test",
        shell_config: nil,
        type: "http"
      }
    ]
  end

  describe ".read" do
    # TODO(bianchi): implement tests
    # test "it returns the valid checks"
    # test "it returns {:error, errors} if there are no valid checks"
  end

  describe ".read!" do
    # TODO(bianchi): this doesn't actually do this - it will return the valid checks
    # even if some checks are not valid
    test "it returns the checks directly if there are no errors", fixture do
      assert Monitor.CheckReader.read!("test/fixtures/checks/fake_check.yaml") == [fixture.test_check]
    end

    test "it raises an error if the check type cannot be found" do
      assert_raise Monitor.Error.CheckValidationError, fn -> Monitor.CheckReader.read!("test/fixtures/checks/incomplete_check.yaml") end
    end

    test "it raises an error with a meaningful message" do
      assert_raise Monitor.Error.CheckValidationError, fn -> Monitor.CheckReader.read!("test/fixtures/checks/incomplete_check.yaml") end
    end
  end
end
