defmodule ParserCombinators.MixProject do
  use Mix.Project

  def project do
    [
      app: :parser_combs,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/guenni68/parser_combs.git"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:monad_cps, "~> 0.1.0"},
      {:stream_data, ">= 0.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    This package provides a parser combinator library similar to Haskell's Parsec.
    """
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/guenni68/parser_combs.git"}
    ]
  end
end
