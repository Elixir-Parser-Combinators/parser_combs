defmodule Parser.Instances do
  @moduledoc false

  use Control.Monad
  use Control.Alternative

  @success :success
  @failure :failure

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      use Control.Monad
    end
  end

  defmacro inject_elem(fun) do
    quote do
      def elem() do
        fn
          input ->
            case(unquote(fun).(input)) do
              {:ok, value, remainder} ->
                {unquote(@success), value, remainder}

              :error ->
                unquote(@failure)
            end
        end
      end
    end
  end

  inject_bind_return(
    &_bind/2,
    &_return/1
  )

  defp _bind(ma, a2mb) do
    fn input ->
      case ma.(input) do
        @failure -> @failure
        {@success, value, remainder} -> a2mb.(value).(remainder)
      end
    end
  end

  defp _return(a) do
    fn input -> {@success, a, input} end
  end

  inject_empty_choice(
    fn _ -> @failure end,
    &_choice/2
  )

  defp _choice(pa1, pa2) do
    fn input ->
      case pa1.(input) do
        @failure -> pa2.(input)
        {@success, _value, _remainder} = success -> success
      end
    end
  end
end
