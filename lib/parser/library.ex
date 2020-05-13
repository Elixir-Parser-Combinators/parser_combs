defmodule Parser.Library do
  @moduledoc """
  This module provides a few basic parsers. Has to be imported explicitly.
  """

  use Parser.Core
  import Parser.Combinators

  @doc """
  accepts a single character and produces a parser that succeeds if the input string
  begins with that character.
  """
  def char(c) do
    satisfy(fn x -> x == c end)
  end

  @doc """
  accepts a string and produces a parser that succeeds if the input string begins with that string.
  Case sensitive.
  """
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

  @doc """
  parser that succeed if the input string starts with \s
  """
  def space() do
    char(?\s)
  end

  @doc """
  parser that succeeds if the input string starts with \n. Consumes every following \s of the input string.
  """
  def spaces() do
    some(space())
  end

  @doc """
  parser that succeeds if the input string starts with with a digit from 1..9
  """
  def digit_non_zero do
    satisfy(fn x -> x in ?1..?9 end)
  end

  @doc """
  parser that succeeds if the input string starts with '0'
  """
  def zero() do
    char(?0)
  end

  @doc """
  parser that succeeds if the input string start with a digit within 0..9
  """
  def digit() do
    zero() <|> digit_non_zero()
  end

  @doc """
  parser that succeeds if the input string starts with a digit. Returns a string composed of
  all subsequent digits found.
  """
  def digits() do
    fmap(&to_string/1, some(digit()))
  end

  @doc """
  parser that succeeds if the input string starts with a letter.
  """
  def alpha() do
    satisfy(fn x -> x in Enum.concat(?a..?z, ?A..?Z) end)
  end

  @doc """
  parser that succeed if the input string starts with either a digit of letter.
  """
  def alphanumeric() do
    digit() <|> alpha()
  end
end
