defmodule Fw.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [worker(Fw.WatchDog, [])]
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
