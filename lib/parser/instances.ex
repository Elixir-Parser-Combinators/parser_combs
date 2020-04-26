defmodule Parser.Instances do
  @moduledoc false

  import Typeclasses.Monad

  @success :success
  @failure :failure

  inject_fmap_empty_choice_bind_return(
    &_fmap/2,
    fn _ -> @failure end,
    &_choice/2,
    &_bind/2,
    &_return/1
  )

  defmacro defelem(fun) do
    quote do
      def elem() do
        fn input ->
          case unquote(fun).(input) do
            {:ok, value, remainder} -> {unquote(@success), value, remainder}
            :error -> unquote(@failure)
          end
        end
      end

      defmonadic satisfy(fun) do
        x <- elem()

        if(fun.(x)) do
          return(x)
        else
          empty()
        end
      end
    end
  end

  defp _fmap(a2b, fa) do
    fn input ->
      case fa.(input) do
        @failure -> @failure
        {@success, value, remainder} -> {@success, a2b.(value), remainder}
      end
    end
  end

  defp _choice(pa1, pa2) do
    fn input ->
      case pa1.(input) do
        @failure -> pa2.(input)
        {@success, _value, _remainder} = success -> success
      end
    end
  end

  defp _bind(pa, a2pb) do
    fn input ->
      case pa.(input) do
        @failure -> @failure
        {@success, value, remainder} -> a2pb.(value).(remainder)
      end
    end
  end

  defp _return(a) do
    fn input -> {@success, a, input} end
  end
end
