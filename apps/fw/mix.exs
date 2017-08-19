defmodule Fw.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rosetta_rpi3"

  def project do
    [app: :fw,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.5.1"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     lockfile: "mix.lock",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(Mix.env),
     elixir: "~> 1.4",
     deps: deps() ++ system(@target, Mix.env)]
  end

  def application do
    [
      mod: {Fw.Application, []},
      applications: applications(Mix.env) ++ general_applications(),
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

  defp applications(:prod), do: [:nerves, :nerves_firmware_http, :nerves_runtime]
  defp applications(_), do: []

  defp general_applications() do
    [
      :logger,
      :poison,
      :cicada,
      :interface,
      :cloud_logger,
      :automation,
      :rosetta_home_chromecast,
      :rosetta_home_radio_thermostat,
      :rosetta_home_ieq_sensor,
      :rosetta_home_lifx,
      :rosetta_home_raven_smcd,
      :rosetta_home_meteo_stick,
      :rosetta_home_neurio,
    ]
  end

  defp deps do
    [
      {:nerves, "~> 0.6.1", override: true},
      {:nerves_firmware_http, github: "nerves-project/nerves_firmware_http", only: :prod},
      {:nerves_runtime, "~> 0.4.0"},
      {:distillery, "~> 1.2"},
      {:poison, "~> 3.0", override: true},
      {:cicada, github: "rosetta-home/cicada", override: true},
      {:interface, in_umbrella: true},
      {:cloud_logger, in_umbrella: true},
      {:automation, in_umbrella: true},
      {:rosetta_home_radio_thermostat,  github: "rosetta-home/rosetta_home_radio_thermostat"},
      {:rosetta_home_chromecast, github: "rosetta-home/rosetta_home_chromecast"},
      {:rosetta_home_ieq_sensor, github: "rosetta-home/rosetta_home_ieq_sensor"},
      {:rosetta_home_lifx, github: "rosetta-home/rosetta_home_lifx"},
      {:rosetta_home_raven_smcd, github: "rosetta-home/rosetta_home_raven_smcd"},
      {:rosetta_home_meteo_stick, github: "rosetta-home/rosetta_home_meteo_stick"},
      {:rosetta_home_neurio, github: "rosetta-home/rosetta_home_neurio"},
    ]
  end
  def system("rosetta_rpi3", :prod) do
    [{:"rosetta_rpi3", path: "/app/rosetta-home/rosetta_rpi3"}]
  end
  def system(_, _), do: []

  def aliases(:prod) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end
  def aliases(_), do: []
end
