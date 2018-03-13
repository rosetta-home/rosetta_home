defmodule Interface.UI.Network do
  require Logger
  alias Cicada.{NetworkManager}

  @headers [
    {"cache-control", "no-cache"},
    {"connection", "close"},
    {"content-type", "text/html"},
    {"expires", "Mon, 3 Jan 2000 12:34:56 GMT"},
    {"pragma", "no-cache"},
    {"Access-Control-Allow-Origin", "*"},
  ]

  defmodule State do
    defstruct hostname: nil
  end

  def init({:tcp, :http}, req, _opts) do
    Process.send_after(self(), :scan, 0)
    {:loop, req, %State{}, 5_000}
  end

  def info(:scan, req, state) do
    st = EEx.eval_file(Path.join(:code.priv_dir(:interface), "network.html.eex"), [])
    {:ok, req2} = :cowboy_req.reply(200, @headers, st, req)
    {:ok, req2, state}
  end

  def terminate(_reason, _req, _state), do: :ok

end
