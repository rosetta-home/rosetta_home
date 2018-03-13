defmodule Interface.Mixfile do
  use Mix.Project

  def project do
    [app: :interface,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :cowboy, :mdns, :eex, :nerves, :cicada, :poison],
      mod: {Interface.Application, []},
      env: [port: System.get_env("INTERFACE_PORT")]
    ]
  end

  defp deps do
    [
      {:nerves, "~> 0.7", override: true},
      {:cicada, github: "rosetta-home/cicada", override: true},
      {:cowboy, "~> 1.0"},
      {:mdns, "~> 0.1.5"},
      {:poison, "~> 3.0", override: true},
    ]
  end
end
