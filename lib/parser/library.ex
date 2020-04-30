defmodule Parser.Library do
  @moduledoc false

  use Parser.Core
  import Parser.Combinators

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

  def space() do
    some(char(?\s))
  end

  def digit_non_zero do
    satisfy(fn x -> x in '123456789' end)
  end

  def zero() do
    char(?0)
  end

  def digit() do
    zero() <|> digit_non_zero()
  end

  def digits() do
    some(digit())
  end
end
