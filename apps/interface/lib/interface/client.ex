defmodule Interface.Client do
  use GenServer
  require Logger
  alias Cicada.{NetworkManager, EventManager}
  alias Cicada.NetworkManager.State, as: NM
  alias Cicada.NetworkManager.Interface, as: NMInterface

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    NetworkManager.register
    Mdns.Server.add_service(%Mdns.Server.Service{
      domain: "rosetta.local",
      data: :ip,
      ttl: 120,
      type: :a
    })
    {:ok, %{started: false}}
  end

  def handle_info(%NM{interface: %NMInterface{settings: %{ipv4_address: address}}, bound: true}, %{started: started} = state) do
    Logger.info "mDNS IP Set: #{address}"
    {:ok, ip} = '#{address}' |> :inet.parse_address
    Mdns.Server.set_ip(ip)
    case started do
      false -> Mdns.Server.start
      true -> nil
    end
    {:noreply, state}
  end

  def handle_info(%NM{}, state) do
    {:noreply, state}
  end

  def handle_info(mes, state) do
    {:noreply, state}
  end

  def handle_call(:register, {pid, _ref}, state) do
    Registry.register(EventManager.Registry, Interface, pid)
    {:reply, :ok, state}
  end

  def dispatch(event) do
    EventManager.dispatch(Interface, event)
  end

end
