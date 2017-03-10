defmodule CloudLogger.Worker do
  use GenServer
  require Logger
  alias Cicada.DataManager

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :send_data, 1000)
    {:ok, %{}}
  end

  def handle_info(:send_data, state) do
    devices =
      DataManager.Histogram.snapshot() |> Enum.map(fn device ->
        vs = device.values |> Enum.reduce(%{}, fn({k, v}, acc) ->
          acc |> Map.put(k, v |> Map.delete(:values))
        end)
        %{ device | device: Map.delete(device.device, :device_pid), values: vs}
      end)
    Logger.info "#{inspect devices}"
    devices |> CloudLogger.MQTT.send
    Process.send_after(self(), :send_data, 10*1000)
    {:noreply, state}
  end

end
