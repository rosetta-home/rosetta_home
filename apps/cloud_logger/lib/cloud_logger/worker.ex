defmodule CloudLogger.Worker do
  use GenServer
  require Logger
  alias Cicada.DeviceManager

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :send_data, 10000)
    {:ok, %{}}
  end

  def handle_info(:send_data, state) do
    devices = DeviceManager.Client.snapshot() |> Enum.map(fn device ->
      %{ device | device: Map.delete(device.device, :device_pid)}
    end)
    Logger.info "#{inspect devices}"
    devices |> CloudLogger.MQTT.send
    Process.send_after(self(), :send_data, 60*1000)
    {:noreply, state}
  end

end
