defmodule Parser do
  defmacro __using__(_options) do
    quote do
      import Parser.Instances
      import Typeclasses.Macros
      import Parser.Combinators
    end
  end
end
