defmodule Interface.WebSocketHandler do
  require Logger
  alias Cicada.{DeviceManager, SysMon}
  @behaviour :cowboy_websocket_handler
  @timeout 60000

  defmodule Message do
    @derive [Poison.Encoder]
    defstruct [:type, :data_point]
  end

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    DeviceManager.register
    {:ok, req, %{}, @timeout}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    Logger.info("PING")
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, message}, req, state) do
    message |> Poison.decode! |> handle_message
    {:reply, {:text, "ok"}, req, state}
  end

  def websocket_info(:shutdown, req, state) do
    {:shutdown, req, state}
  end

  def websocket_info(message, req, state) do
    dp = message |> Map.drop([:device_pid, :histogram, :timer])
    message  = %Message{type: "DATA_POINT", data_point: dp}
    {:reply, {:text, message |> Poison.encode!}, req, state}
  end

  def websocket_terminate(_reason, _req, _state), do: :ok

  def handle_message(%{"type" => "SEND_ACTION"} = action) do
    pid = action |> Map.get("action") |> String.to_existing_atom()
    value = action |> Map.get("payload")
    case value do
      1 -> pid |> Hardware.Actuator.on()
      0 -> pid |> Hardware.Actuator.off()
    end
  end
end
