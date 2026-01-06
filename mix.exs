defmodule Nvml.MixProject do
  use Mix.Project

  @version "0.2.5"
  @source_url "https://github.com/nyo16/nvml_ex"

  def project do
    [
      app: :nvml,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description(),
      name: "Nvml",
      source_url: @source_url,
      docs: docs()
    ]
  end

  defp description do
    "Elixir bindings for NVIDIA Management Library (NVML) via Rust NIFs"
  end

  defp package do
    [
      name: "nvml",
      maintainers: ["Niko"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      files: ~w(
        lib
        native
        mix.exs
        README.md
        LICENSE
        CHANGELOG.md
        checksum-Elixir.Nvml.Native.exs
        .formatter.exs
      )
    ]
  end

  defp docs do
    [
      main: "Nvml",
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Nvml.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.34", optional: true},
      {:rustler_precompiled, "~> 0.8"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
