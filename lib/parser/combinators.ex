defmodule Parser.Combinators do
  @moduledoc false

  use Parser.Continuation

  def satisfy(fun?) do
    monad do
      x <- ic(elem())

      if(fun?.(x)) do
        return(x)
      else
        ic(empty())
      end
    end
  end

  def char(c) do
    satisfy(fn x -> x == c end)
  end
end
