defmodule Fw.WatchDog do
  use GenServer
  require Logger
  alias Cicada.DeviceManager
  alias Cicada.DeviceManager.{Discovery}

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :running, 0)
    {:ok, %{}}
  end

  def handle_info(:running, state) do
    case DeviceManager.Client |> Process.whereis do
      nil -> register_devices()
      _ -> nil
    end
    Process.send_after(self(), :running, 1000)
    {:noreply, state}
  end

  def register_devices do
    DeviceManager.register_plugins([
      #Discovery.Light.Lifx,
      Discovery.HVAC.RadioThermostat,
      #Discovery.MediaPlayer.Chromecast,
      Discovery.WeatherStation.MeteoStick,
      Discovery.SmartMeter.RavenSMCD,
      Discovery.SmartMeter.Neurio,
      Discovery.IEQ.Sensor
    ])
  end

end
