defmodule ExKuna.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_kuna,
      version: "0.1.0",
      elixir: "~> 1.5",
      config_path: "config/config.exs",
      deps_path: "deps",
      start_permanent: Mix.env == :prod,
      build_embedded: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1.0"},
      {:httpoison, "~> 0.13"},
      {:dogma, "~> 0.1"}
    ]
  end
end
