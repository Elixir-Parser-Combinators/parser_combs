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

  defp _elem() do
    fn
      <<char::utf8, remainder::binary>> -> {@success, char, remainder}
      _ -> @failure
    end
  end

  def elem() do
    ic(_elem())
  end

  defp _empty() do
    const(@failure)
  end

  def empty() do
    ic(_empty())
  end

  def ic(parser) do
    make_ic(&_bind/2).(parser)
  end

  def run(m) do
    make_run(&_return/1).(m)
  end

  def parse(parser, input) do
    run(parser).(input)
  end
end