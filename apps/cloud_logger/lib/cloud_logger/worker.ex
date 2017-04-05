defmodule CloudLogger.Worker do
  use GenServer
  require Logger
  alias Cicada.DeviceManager
  alias Cicada.DeviceManager.Device.Histogram

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :send_data, 10000)
    {:ok, %{}}
  end

  def handle_info(:send_data, state) do
    devices = DeviceManager.devices |> Enum.map(fn {pid, module, device} ->
      values = Histogram.snapshot(device.histogram)
      Histogram.reset(device.histogram)
      d =
        module.device(pid)
        |> Map.delete(:device_pid)
        |> Map.delete(:histogram)
      %{device: d, values: values}
    end)
    Logger.info "#{inspect devices}"
    devices |> CloudLogger.MQTT.send
    Process.send_after(self(), :send_data, 59*1000)
    {:noreply, state}
  end

end
