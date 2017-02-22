defmodule Interface.UI.ResetNetwork do
  require Logger
  alias Cicada.{NetworkManager}

  defmodule State do
    defstruct hostname: nil
  end

  def init({:tcp, :http}, req, _opts) do
    {host, req} = :cowboy_req.host(req)
    {:ok, req, %State{:hostname => host }}
  end

  def handle(req, state) do
    :ok = NetworkManager.WiFi.delete_creds
    networks = NetworkManager.WiFi.scan
    st = EEx.eval_file(Path.join(:code.priv_dir(:interface), "network.html.eex"), [networks: networks])
    headers = [
        {"cache-control", "no-cache"},
        {"connection", "close"},
        {"content-type", "text/html"},
        {"expires", "Mon, 3 Jan 2000 12:34:56 GMT"},
        {"pragma", "no-cache"},
        {"Access-Control-Allow-Origin", "*"},
    ]
    {:ok, req2} = :cowboy_req.reply(200, headers, st, req)
    {:ok, req2, state}
  end

  def terminate(_reason, _req, _state), do: :ok

end
