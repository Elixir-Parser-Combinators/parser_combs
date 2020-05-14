defmodule ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  use ParserCombinators

  def curry3(fun) do
    fn a -> fn b -> fn c -> fun.(a, b, c) end end end
  end

  describe "testing typeclass laws" do
    property "testing functor laws, fmap" do
      check all(input <- binary(), n <- integer()) do
        for fun <- [fn x -> x end, fn x -> x + 1 end] do
          assert parse(fmap(fun, pure(n)), input) == parse(pure(fun.(n)), input)
        end
      end
    end

    property "testing applicative laws, pure and <~>" do
      check all(input <- binary(), a <- integer(), b <- integer(), c <- integer()) do
        for fun <- [fn a, b, c -> a + b + c end] do
          assert parse(pure(curry3(fun)) <~> pure(a) <~> pure(b) <~> pure(c), input) ==
                   parse(pure(fun.(a, b, c)), input)
        end
      end
    end

    property "testing monad laws" do
      check all(input <- binary(), a <- integer(), b <- integer()) do
        for f <- [fn x -> return(a + x) end, fn x -> return(a * x * 5) end],
            g <- [fn x -> return(a * x - 5) end, fn x -> return(a * 14 - x) end] do
          assert parse(return(b) ~>> f, input) ==
                   parse(f.(b), input)

          assert parse(return(b) ~>> (&return/1), input) ==
                   parse(return(b), input)

          assert parse(return(b) ~>> f ~>> g, input) ==
                   parse(return(b) ~>> fn x -> f.(x) ~>> g end, input)
        end
      end
    end
  end
end
