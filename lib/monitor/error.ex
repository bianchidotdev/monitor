defmodule Monitor.Error do
  defexception message: nil, id: nil
end

defmodule Monitor.Error.CheckValidationError do
  defexception message: nil, id: nil
end
