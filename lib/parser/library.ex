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
    char(?\s)
  end

  def spaces() do
    some(space())
  end
  
  def digit_non_zero do
    satisfy(fn x -> x in ?1..?9 end)
  end

  def zero() do
    char(?0)
  end

  def digit() do
    zero() <|> digit_non_zero()
  end

  def digits() do
    fmap(&to_string/1, some(digit()))
  end

  def alpha() do
    satisfy(fn x -> x in Enum.concat(?a..?z, ?A..?Z) end)
  end

  def alphanumeric() do
    digit() <|> alpha()
  end
end
