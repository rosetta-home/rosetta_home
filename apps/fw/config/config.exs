# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config
require Logger

config :logger,
  backends: [:console],
  compile_time_purge_level: :info,
  level: :info

config :nerves, :firmware,
  fwup_conf: "config/rpi3/fwup.conf",
  rootfs_additions: "config/rpi3/rootfs-additions"

config :cipher,
  keyphrase: System.get_env("CIPHER_KEYPHRASE"),
  ivphrase: System.get_env("CIPHER_IV"),
  magic_token: System.get_env("CIPHER_TOKEN")

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
