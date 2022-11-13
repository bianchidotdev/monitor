ExUnit.start()

Application.put_env(:monitor, :http_client, Monitor.HTTPClientMock)
