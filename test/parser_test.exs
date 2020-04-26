defmodule ParserTest do
  use ExUnit.Case
  use ExUnitProperties

  import Parser.Instances

  def curry3(fun) do
    fn a -> fn b -> fn c -> fun.(a, b, c) end end end
  end

  describe "testing typeclass laws" do
    property "testing functor laws, fmap" do
      check all(input <- binary(), n <- integer()) do
        for fun <- [fn x -> x end, fn x -> x + 1 end] do
          assert fmap(fun, pure(n)).(input) == pure(fun.(n)).(input)
        end
      end
    end

    property "testing applicative laws, pure and <~>" do
      check all(input <- binary(), a <- integer(), b <- integer(), c <- integer()) do
        for fun <- [fn a, b, c -> a + b + c end] do
          assert (pure(curry3(fun)) <~> pure(a) <~> pure(b) <~> pure(c)).(input) ==
                   pure(fun.(a, b, c)).(input)
        end
      end
    end

    property "testing alternative laws" do
      check all(input <- binary(), n <- integer()) do
        assert (pure(n) <|> empty()).(input) == pure(n).(input)
        assert (empty() <|> pure(n)).(input) == pure(n).(input)
      end
    end

    property "testing monad laws" do
      check all(input <- binary(), a <- integer(), b <- integer()) do
        for f <- [fn x -> return(a + x) end, fn x -> return(a * x * 5) end],
            g <- [fn x -> return(a * x - 5) end, fn x -> return(a * 14 - x) end] do
          assert (return(b) ~>> f).(input) ==
                   f.(b).(input)

          assert (return(b) ~>> (&return/1)).(input) ==
                   return(b).(input)

          assert (return(b) ~>> f ~>> g).(input) ==
                   (return(b) ~>> fn x -> f.(x) ~>> g end).(input)
        end
      end
    end
  end
end
