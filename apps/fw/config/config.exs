# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
require Logger

config :nerves_interim_wifi,
  regulatory_domain: "US"

config :sasl, errlog_type: :error

config :logger,
  backends: [:console],
  level: :info,
  compile_time_purge_level: :info

config :nerves, :firmware,
  fwup_conf: "config/rpi0/fwup.conf",
  rootfs_additions: "config/rpi0/rootfs-additions"

config :cipher,
  keyphrase: System.get_env("CIPHER_KEYPHRASE"),
  ivphrase: System.get_env("CIPHER_IV"),
  magic_token: System.get_env("CIPHER_TOKEN")

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
