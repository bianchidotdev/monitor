defmodule Monitor.CheckReaderTest do
  use ExUnit.Case, async: true

  test "it raises an error if the check type cannot be found" do
    assert_raise Monitor.Error.CheckValidationError, fn -> Monitor.CheckReader.read!("test/fixtures/checks/incomplete_check.yaml") end
  end
end
