defmodule Monitor.CheckExecutorTest do
  use ExUnit.Case, async: true

  import Mox
  setup :verify_on_exit!

  doctest Monitor.CheckExecutor

  @mock_check Monitor.CheckReader.read!("test/fixtures/checks/fake_check.yaml") |> List.first()

  test "it returns :ok and the response when successful" do
    expect(Monitor.HTTPClientMock, :request, fn _, _ ->
      {:ok, %HTTPoison.Response{status_code: 200, body: "200 OK"}}
    end)

    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, "200 OK"}
  end

  test "it returns :ok with the error message and the response when unsuccessful" do
    expect(Monitor.HTTPClientMock, :request, fn _, _ ->
      {:ok, %HTTPoison.Response{status_code: 500, body: "500 Internal Server Error"}}
    end)

    # TODO(bianchi): mock error call
    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, "500 Internal Server Error"}
  end

  test "it returns :ok with the error message in the case of a timeout" do
    expect(Monitor.HTTPClientMock, :request, fn _, _ ->
      {:error, %HTTPoison.Error{reason: :timeout, id: nil}}
    end)

    assert Monitor.CheckExecutor.perform(@mock_check) == {:ok, :timeout}
  end

  # TODO(bianchi): test side-effects - dropping events maybe?
end
