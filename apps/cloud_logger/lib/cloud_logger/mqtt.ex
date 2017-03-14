defmodule CloudLogger.MQTT do
  use GenMQTT
  require Logger

  @host System.get_env("MQTT_HOST")
  @port System.get_env("MQTT_PORT") |> String.to_integer

  def start_link do
    client = Cicada.NetworkManager.BoardId.get
    Logger.info "MQTT Client #{client} Connecting: #{@host}:#{@port}"
    priv_dir = :code.priv_dir(:cloud_logger)
    transport = {:ssl, [{:certfile, "#{priv_dir}/ssl/cicada.crt"}, {:keyfile, "#{priv_dir}/ssl/cicada.key"}]}
    GenMQTT.start_link(__MODULE__, nil, host: @host, port: @port, name: __MODULE__, client: client, transport: transport)
  end

  def on_connect(state) do
    client = Cicada.NetworkManager.BoardId.get
    Logger.info "MQTT Connected"
    :ok = GenMQTT.subscribe(self, "node/#{client}/+", 0)
    {:ok, state}
  end

  def on_publish(["node", client, "payload"], message, state) do
    Logger.info "#{client} Published: #{inspect message}"
    {:ok, state}
  end

  def send(payload) do
    client = Cicada.NetworkManager.BoardId.get
    CloudLogger.MQTT |> GenMQTT.publish("node/#{client}/payload", payload |> Poison.encode!, 0)
  end
end
