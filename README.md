# ParserCombinators

This package provides parser combinators in the style of Haskell's Parsec library.

```elixir
use ParserCombinators
import Parser.Library

defp char_list_to_integer(cs) do
  cs 
  |> to_string() 
  |> String.to_integer()
end

def birth_date() do
  monad do
    mm <- fmap(&char_list_to_integer/1, count(2, digit()))
    char(?/)
    dd <- fmap(&char_list_to_integer/1, count(2, digit()))
    char(?))
    yyyy <- fmap(&char_list_to_integer/1, count(4, digit()))
    return (%{year: yyyy, day: dd, month: mm})
  end
end

{:ok, dob} = run_parser(birth_date(),  "04/27/1985")

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:parser_combs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/parser](https://hexdocs.pm/parser).

