defmodule CloudLogger.MQTT do
  use GenMQTT
  require Logger

  @host System.get_env("MQTT_HOST")
  @port System.get_env("MQTT_PORT") |> String.to_integer

  def start_link do
    client = "Node:#{Cicada.NetworkManager.BoardId.get}"
    Logger.info "MQTT Client #{client} Connecting: #{@host}:#{@port}"
    priv_dir = :code.priv_dir(:cloud_logger)
    transport = {:ssl, [{:certfile, "#{priv_dir}/ssl/cicada.crt"}, {:keyfile, "#{priv_dir}/ssl/cicada.key"}]}
    GenMQTT.start_link(__MODULE__, nil, host: @host, port: @port, name: __MODULE__, client: client, transport: transport)
  end

  def on_connect(state) do
    client = "Node:#{Cicada.NetworkManager.BoardId.get}"
    Logger.info "MQTT Connected"
    :ok = GenMQTT.subscribe(self(), "node/#{client}/+", 0)
    {:ok, state}
  end

  def on_publish(["node", client, "payload"], message, state) do
    Logger.info "#{client} Published: #{inspect message}"
    {:ok, state}
  end

  def on_publish(["node", _client, "request"], message, state) do
    client = "Node:#{Cicada.NetworkManager.BoardId.get}"
    {reply, state} =
      case Poison.decode(message) do
        {:ok, mes} -> mes |> handle_request(state)
        {:error, er} -> {%{message: er}, state}
      end
    CloudLogger.MQTT |> GenMQTT.publish("node/#{client}/response", reply |> Poison.encode!, 0)
    {:ok, state}
  end

  def on_publish(_other, message, state) do
    Logger.info "Published: #{inspect message}"
    {:ok, state}
  end

  def handle_request(%{"type" => "configure_touchstone"} = message, state) do
    1..3 |> Enum.each(fn _i ->
      Cicada.DeviceManager.Device.IEQ.Sensor.set_mode(:"Sensor-IEQStation-#{message["payload"]["id"]}", :green)
      :timer.sleep(300)
    end)
    {%{result: :ok}, state}
  end

  def handle_request(message, state) do
    Logger.error "Unknown request type: #{inspect message}"
    {%{result: :error}, state}
  end

  def send(payload) do
    client = "Node:#{Cicada.NetworkManager.BoardId.get}"
    CloudLogger.MQTT |> GenMQTT.publish("node/#{client}/payload", payload |> Poison.encode!, 0)
  end
end
