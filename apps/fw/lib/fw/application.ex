defmodule Fw.Application do
  alias Cicada.DeviceManager
  alias Cicada.DeviceManager.{Discovery}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    register_devices()
    children = []
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def register_devices do
    DeviceManager.Registry.add([
      Discovery.Light.Lifx,
      Discovery.HVAC.RadioThermostat,
      Discovery.MediaPlayer.Chromecast,
      Discovery.WeatherStation.MeteoStick,
      Discovery.SmartMeter.RavenSMCD,
      Discovery.SmartMeter.Neurio,
      Discovery.IEQ.Sensor
    ])
  end
end
