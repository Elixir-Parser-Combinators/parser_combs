defmodule ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  use Parser

  def curry3(fun) do
    fn a -> fn b -> fn c -> fun.(a, b, c) end end end
  end

  describe "testing typeclass laws" do
    property "testing functor laws, fmap" do
      check all(input <- binary(), n <- integer()) do
        for fun <- [fn x -> x end, fn x -> x + 1 end] do
          assert run(fmap(fun, pure(n))).(input) == run(pure(fun.(n))).(input)
        end
      end
    end

    property "testing applicative laws, pure and <~>" do
      check all(input <- binary(), a <- integer(), b <- integer(), c <- integer()) do
        for fun <- [fn a, b, c -> a + b + c end] do
          assert run(pure(curry3(fun)) <~> pure(a) <~> pure(b) <~> pure(c)).(input) ==
                   run(pure(fun.(a, b, c))).(input)
        end
      end
    end

    property "testing monad laws" do
      check all(input <- binary(), a <- integer(), b <- integer()) do
        for f <- [fn x -> return(a + x) end, fn x -> return(a * x * 5) end],
            g <- [fn x -> return(a * x - 5) end, fn x -> return(a * 14 - x) end] do
          assert run(return(b) ~>> f).(input) ==
                   run(f.(b)).(input)

          assert run(return(b) ~>> (&return/1)).(input) ==
                   run(return(b)).(input)

          assert run(return(b) ~>> f ~>> g).(input) ==
                   run(return(b) ~>> fn x -> f.(x) ~>> g end).(input)
        end
      end
    end
  end
end
