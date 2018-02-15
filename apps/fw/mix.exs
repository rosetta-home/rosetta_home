defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [app: :fw,
     version: "0.0.1",
     elixir: "~> 1.5",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.6"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     lockfile: "mix.lock.#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps()]
  end

  def application, do: application(@target)

  def application(target) do
    [
      mod: {Fw.Application, []},
      extra_applications: [:logger], #all other applications are started with bootloader in config.exs
      env: [
        cipher: [
          keyphrase: System.get_env("CIPHER_KEYPHRASE"),
          ivphrase: System.get_env("CIPHER_IV"),
          magic_token: System.get_env("CIPHER_TOKEN")
        ],
        sasl: [errlog_type: :error],
      ]
   ]
  end

  def deps do
    [{:nerves, "~> 0.7"},
     {:poison, "~> 3.0", override: true},
     {:cicada, github: "rosetta-home/cicada", override: true},
     {:interface, in_umbrella: true},
     {:nerves_uart, "~> 1.0", override: true},
     {:cloud_logger, in_umbrella: true},
     {:rosetta_home_radio_thermostat, github: "rosetta-home/rosetta_home_radio_thermostat"},
     {:rosetta_home_chromecast, github: "rosetta-home/rosetta_home_chromecast"},
     {:rosetta_home_ieq_sensor, github: "rosetta-home/rosetta_home_ieq_sensor"},
     {:rosetta_home_lifx, github: "rosetta-home/rosetta_home_lifx"},
     {:rosetta_home_raven_smcd, github: "rosetta-home/rosetta_home_raven_smcd"},
     {:rosetta_home_meteo_stick, github: "rosetta-home/rosetta_home_meteo_stick"},
     {:rosetta_home_neurio, github: "rosetta-home/rosetta_home_neurio"},
     {:nerves_uart, "~> 1.0", override: true}
    ] ++ deps(@target)
  end

  def deps("host"), do: []
  def deps(target) do
    [system(target),
     {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http", only: :prod},
     {:nerves_runtime, "~> 0.4"},
     {:bootloader, "~> 0.1"}]
  end

  def system("rosetta_rpi3"), do: {:"rosetta_rpi3", path: "/app/rosetta-home/rosetta_rpi3", runtime: false}
  def system("rosetta_rpi0"), do: {:rosetta_rpi0, "~> 0.17.2", runtime: false}

  def aliases("host"), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
end
