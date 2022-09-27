defmodule Monitor.InstrumentationHelper do
  defmacro __using__(_) do
    quote do
      require Logger

      def perform(check) do
        Logger.debug("running with #{inspect check}")
        # TODO(bianchi): implement some kind of instrumentation
        run(check)
      end
    end
  end
end
