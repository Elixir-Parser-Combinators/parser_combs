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

  def at_least(0, parser) do
    many(parser)
  end

  def at_least(n, parser) do
    monad do
      x <- parser
      xs <- at_least(n - 1, parser)
      return([x | xs])
    end
  end
end
