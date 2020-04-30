defmodule Parser.Combinators do
  @moduledoc false

  use Parser.Core

  def satisfy(fun?) do
    monad do
      x <- elem()

      if(fun?.(x)) do
        return(x)
      else
        empty()
      end
    end
  end

  def many(parser) do
    some(parser) <|> return([])
  end

  def some(parser) do
    monad do
      x <- parser
      xs <- many(parser)
      return([x | xs])
    end
  end
end
