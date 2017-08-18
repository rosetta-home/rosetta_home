defmodule Automation.HVACCirculation do
  use GenServer
  require Logger
  alias Cicada.DeviceManager

  @duration 1200 #20 minutes in seconds
  @run_every 43200 # 12 hours in seconds

  defmodule State do
    #monotonic time can return very big negative numbers
    defstruct last_run: -99999999999, started: 0, running: false
  end

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :run, 10_000)
    {:ok, %State{}}
  end

  def handle_info(:run, state) do
    Logger.info "Running #{inspect __MODULE__}"
    state = with %DeviceManager.Device{} = hvac <- get_hvac(),
      :off <- hvac.state.state do
      hvac |> fan_on?(state)
    else
      _ -> state
    end
    Process.send_after(self(), :run, 29*1000)
    {:noreply, state}
  end

  def fan_on?(hvac, state) do
    now = :erlang.monotonic_time(:seconds)
    case state.running do
      true ->
        case now - state.started do
          diff when diff > @duration ->
            Logger.info "HVAC off"
            hvac.interface_pid |> hvac.module.fan_off()
            %State{last_run: now, running: false}
          _ -> state
        end
      false ->
        case now - state.last_run do
          diff when diff > @run_every ->
            Logger.info "HVAC on"
            hvac.interface_pid |> hvac.module.fan_on()
            %State{running: true, started: now}
          _ -> state
        end
    end
  end

  def get_hvac() do
    DeviceManager.devices |> Enum.find(fn device ->
      case device.type do
        :hvac -> true
        _ -> false
      end
    end)
  end
end
