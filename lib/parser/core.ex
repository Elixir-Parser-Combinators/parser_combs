defmodule Parser.Core do
  @moduledoc false

  use Control.Continuation

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Control.Continuation
    end
  end

  @success :success
  @failure :failure

  # Monad instance
  defp _bind(ma, a2mb) do
    fn input ->
      case ma.(input) do
        {@success, a, remainder} -> a2mb.(a).(remainder)
        @failure -> @failure
      end
    end
  end

  defp _return(a) do
    fn input -> {@success, a, input} end
  end

  def return(a) do
    ic(_return(a))
  end

  # Alternative instance
  defp _empty() do
    const(@failure)
  end

  def empty() do
    ic(_empty())
  end

  defp _choice(c1, c2) do
    fn input ->
      case {run(c1).(input), run(empty()).(input)} do
        {x, x} -> run(c2).(input)
        {c1x, _} -> c1x
      end
    end
  end

  def c1 <|> c2 do
    ic(_choice(c1, c2))
  end

  # Primitives
  defp _elem() do
    fn
      <<char::utf8, remainder::binary>> -> {@success, char, remainder}
      _ -> @failure
    end
  end

  def elem() do
    ic(_elem())
  end

  # Wrapping / Unwrapping
  def ic(parser) do
    make_ic(&_bind/2).(parser)
  end

  def run(m) do
    make_run(&_return/1).(m)
  end

  # Helper functions
  def parse(parser, input) do
    run(parser).(input)
  end

  def run_parser(parser, input) do
    case parse(parser, input) do
      {@success, result, ""} -> {:ok, result}
      {@success, _, remainder} -> {:error, "incomplete parse, stopped at: #{remainder}"}
      @failure -> {:error, "parsing failed"}
    end
  end

  def run_parser!(parser, input) do
    {:ok, result} = run_parser(parser, input)
    result
  end
end
