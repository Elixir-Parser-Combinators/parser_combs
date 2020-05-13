defmodule Parser.Combinators do
  @moduledoc """
  This module provides basic combinators
  """

  use Parser.Core

  @doc """
  accepts a testing function and produces a parser. The parser succeeds if the element
  picked from the input string and applied to the testing function returns true.
  """
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

  @doc """
  accepts a parser and applies it to the input string until that parser fails.
  Returns a list of parser results. The parser still succeeds even if the result
  list is empty.
  """
  def many(parser) do
    some(parser) <|> return([])
  end

  @doc """
  accepts a parser and applies it to the input string until that parser fails.
  Returns a list of parser results. The parser succeeds if the at least one
  result is produced.
  """
  def some(parser) do
    monad do
      x <- parser
      xs <- many(parser)
      return([x | xs])
    end
  end

  @doc """
  accepts a number n and a parser p which produces a parser np. The parser succeeds
  if parser p can be successfully applied at least n times.
  """
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

  @doc """
  accepts a number n and a parser p. Produces a parser np. Parser np applies
  parser p up to n times. Parser np will always succeed even if parser p cannot
  be applied even once. Returns a list of parser p results which may be empty.
  """
  def up_to(0, _parser) do
    return([])
  end

  def up_to(n, parser) do
    up_to1(n, parser) <|> return([])
  end

  @doc """
  same as up_to/2, but parser p has to succeed at least once
  """
  def up_to1(0, _parser) do
    return([])
  end

  def up_to1(n, parser) do
    monad do
      x <- parser
      xs <- up_to(n - 1, parser)
      return([x | xs])
    end
  end

  @doc """
  accepts a number n and a parser p and returns parser np. Parser np succeeds only if
  parser p is successfully applied n times.
  """
  def count(0, _parser) do
    return([])
  end

  def count(n, parser) do
    monad do
      x <- parser
      xs <- count(n - 1, parser)
      return([x | xs])
    end
  end

  @doc """
  accepts a range m..n and a parser p. Produces a parser pr which succeeds if
  parser p can be applied at least n times.
  """
  def between(m..n, parser) do
    monad do
      cs <- count(m, parser)
      us <- up_to(n - m, parser)
      return(Enum.concat([cs, us]))
    end
  end

  @doc """
  same as &between/2 excepts it accepts a minimum and a maximum value separately instead of a range.
  """
  def between(m, n, parser) do
    between(m..n, parser)
  end

  @doc """
  accepts a parser p and produces a parser that will always succeed. Produces either an empty list
  or a single element list.
  """
  def optional(parser) do
    between(0..1, parser)
  end
end
