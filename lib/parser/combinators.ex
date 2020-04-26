defmodule Parser.Combinators do
  @moduledoc false

  import Parser.Instances
  import Typeclasses.Macros

  def parse(parser, input) do
    parser.(input)
  end

  defmonadic fail(parser) do
    parser
    empty()
  end

  def some(parser) do
    many(parser) <|> return([])
  end

  defmonadic many(parser) do
    x <- parser
    xs <- some(parser)
    return([x | xs])
  end
end
