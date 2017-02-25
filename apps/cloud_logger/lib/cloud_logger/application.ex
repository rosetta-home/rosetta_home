defmodule CloudLogger.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(CloudLogger.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: CloudLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
