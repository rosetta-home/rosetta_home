defmodule Automation.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      worker(Automation.HVACCirculation, []),
    ]

    opts = [strategy: :one_for_one, name: Automation.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
