defmodule Parser.List do
  @moduledoc false

  use Parser.Instances

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Parser.Instances
    end
  end

  inject_elem(&_elem/1)

  defp _elem([]) do
    :error
  end

  defp _elem([h | t]) do
    {:ok, h, t}
  end
end
