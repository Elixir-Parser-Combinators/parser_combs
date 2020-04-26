defmodule Parser.List do
  @moduledoc false

  use Parser

  defelem(&_elem/1)

  defp _elem([]) do
    :error
  end

  defp _elem([h | t]) do
    {:ok, h, t}
  end
end
