defmodule Parser.String do
  @moduledoc false

  use Parser.Instances

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Parser.Instances
      use Parser.Combinators
    end
  end

  inject_elem(&_elem/1)

  defp _elem(<<char::utf8, rest::binary>>) do
    {:ok, char, rest}
  end

  defp _elem(<<>>) do
    :error
  end
end
