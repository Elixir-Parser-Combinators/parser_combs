defmodule Parser.Instances do
  @moduledoc false

  import Typeclasses.Monad

  @success :success
  @failure :failure

  inject_fmap_pure_apply_empty_choice_bind(
    &_fmap/2,
    &_pure/1,
    &_apply/2,
    fn _ -> @failure end,
    &_choice/2,
    &_bind/2
  )

  defp _fmap(a2b, fa) do
    fn input ->
      case fa.(input) do
        @failure -> @failure
        {@success, value, remainder} -> {@success, a2b.(value), remainder}
      end
    end
  end

  defp _pure(value) do
    fn input -> {@success, value, input} end
  end

  defp _apply(pa2b, pa) do
    pa2b ~>> fn a2b -> pa ~>> fn a -> return(a2b.(a)) end end
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
end
