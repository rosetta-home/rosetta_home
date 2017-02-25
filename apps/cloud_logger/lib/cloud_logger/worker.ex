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
    values = DataManager.Histogram.snapshot()
    Logger.info "#{inspect values}"
    #Process.send_after(self(), :send_data, 10*1000)
    {:noreply, state}
  end

end
