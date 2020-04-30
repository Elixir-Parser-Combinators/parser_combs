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

  def char(c) do
    satisfy(fn x -> x == c end)
  end

  def string(<<>>) do
    return(<<>>)
  end

  def string(<<c::utf8, cs::binary>> = input) do
    monad do
      char(c)
      string(cs)
      return(input)
    end
  end
end
