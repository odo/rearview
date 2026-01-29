defmodule Rearview.MixProject do
  use Mix.Project

  def project do
    [
      app: :rearview,
      version: "0.1.2",
      elixir: "~> 1.18",
      package: package(),
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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end
  
  defp package() do
    [
     name: "rearview",
     description: "Linearized, non-destructive undo-redo-stack",
     links: %{"GitHub" => "https://github.com/odo/rearview"},
     licenses: ["MIT"],
    ]
  end
end
