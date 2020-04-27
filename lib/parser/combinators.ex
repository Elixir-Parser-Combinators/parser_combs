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

  # TODO find more elegant solution
  def try_parse(parser) do
    fn input ->
      case parser.(input) do
        {:success, value, _remainder} -> return(value).(input)
        failure -> failure
      end
    end
  end

  # TODO find more elegant solution
  def many_till(parser, end_parser) do
    end_parser
    ~>> fn _ -> return([]) end
    <|> (parser ~>> fn x -> many_till(parser, end_parser) ~>> fn xs -> return([x | xs]) end end)
  end
end
