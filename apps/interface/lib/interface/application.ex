defmodule Interface.Application do

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(Interface.Client, []),
      worker(Interface.TCPServer, []),
    ]

    opts = [strategy: :one_for_one, name: Interface.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
