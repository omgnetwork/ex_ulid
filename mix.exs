defmodule ExULID.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ulid,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      name: "ExULID",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/omisego/ex_ulid"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.11", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Universally Unique Lexicographically Sortable Identifier (ULID) in Elixir."
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", "AUTHORS"],
      maintainers: ["Unnawut Leepaisalsuwanna"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/omisego/ex_ulid"}
    ]
  end
end
