defmodule Parser.Core do
  @moduledoc """
  This module provides the monad instance definition for a parser.

  A parser essentially is a function that consumes (part of) a string and produces a
  value and the unconsumed part of the string.
  """

  use ContinuationMonad

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use ContinuationMonad
    end
  end

  @parser :parser

  @success :success
  @failure :failure

  def parser(fun) do
    {@parser, fun}
  end

  # Monad instance
  defp _bind({@parser, g}, f) do
    parser(fn input ->
      case g.(input) do
        {@success, a, remainder} ->
          {@parser, h} = f.(a)
          h.(remainder)

        @failure ->
          @failure
      end
    end)
  end

  defp _return(a) do
    parser(fn input -> {@success, a, input} end)
  end

  @doc """
  injects the passed value into function that accepts a string and returns
  a pair of the injected value and the unchanged string
  """
  def return(a) do
    ic(_return(a))
  end

  # Alternative instance
  defp _empty() do
    parser(const(@failure))
  end

  @doc """
  function that accepts a string and always fails.
  """
  def empty() do
    ic(_empty())
  end

  defp _choice(c1, c2) do
    parser(fn input ->
      case {parse(c1, input), parse(empty(), input)} do
        {x, x} -> parse(c2, input)
        {c1x, _} -> c1x
      end
    end)
  end

  @doc """
  accepts 2 parsers a and b and first applies parser a. If that that parser fails parser b applies.
  """
  def c1 <|> c2 do
    ic(_choice(c1, c2))
  end

  # Primitives
  defp _elem() do
    parser(fn
      <<char::utf8, remainder::binary>> -> {@success, char, remainder}
      _ -> @failure
    end)
  end

  @doc """
  single element parser.
  """
  def elem() do
    ic(_elem())
  end

  # Wrapping / Unwrapping
  defp ic(parser) do
    make_ic(&_bind/2).(parser)
  end

  defp run(m) do
    make_run(&_return/1).(m)
  end

  # Helper functions
  @doc """
  applies the parser to the input string, returns value and remaining string
  """
  def parse(parser, input) do
    run(parser)
    |> (fn {@parser, fun} -> fun.(input) end).()
  end

  @doc """
  applies the parser and returns {:ok, result} on successful parse when there is no more input left.
  Returns {:error, reason} if either the parser failed or the input string was not consumed entirely.
  """
  def run_parser(parser, input) do
    case parse(parser, input) do
      {@success, result, ""} -> {:ok, result}
      {@success, _, remainder} -> {:error, "incomplete parse, stopped at: #{remainder}"}
      @failure -> {:error, "parsing failed"}
    end
  end

  @doc """
  applies the parser and returns an un-wrapped value. Raises an error if the parser failed, or
  the parser succeeded but the input was not consumed entirely.
  """
  def run_parser!(parser, input) do
    case run_parser(parser, input) do
      {:ok, result} -> result
      {:error, reason} -> raise(reason)
    end
  end
end
