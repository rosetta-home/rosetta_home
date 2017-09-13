defmodule Fw.Application do
  use Application
  alias Cicada.DeviceManager
  alias Cicada.DeviceManager.{Discovery}

  def start(_type, _args) do
    register_devices()
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
