defmodule ParserCombinators do
  @moduledoc """
  """

  defmacro __using__(_options) do
    quote do
      use Parser.Core
      import Parser.Combinators
    end
  end
end
