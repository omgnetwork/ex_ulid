defmodule ExULID.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ulid,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 0.11", only: :dev},
      {:ecto, "~> 2.2.9", optional: true},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end
end
