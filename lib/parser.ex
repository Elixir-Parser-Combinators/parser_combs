defmodule Parser do
  defmacro __using__(_options) do
    quote do
      use Parser.Continuation
      import Parser.Combinators
    end
  end
end
