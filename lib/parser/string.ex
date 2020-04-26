defmodule Parser.String do
  @moduledoc false

  use Parser

  defelem(&_elem/1)

  defp _elem(<<char::utf8, rest::binary>>) do
    {:ok, char, rest}
  end

  defp _elem(<<>>) do
    :error
  end

  def char(x) do
    satisfy(fn y -> y == x end)
  end
end
