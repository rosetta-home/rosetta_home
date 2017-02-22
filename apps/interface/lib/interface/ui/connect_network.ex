defmodule Interface.UI.ConnectNetwork do
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
    {:ok, kv, req2} = :cowboy_req.body_qs(req)
    Logger.info "Creds: #{inspect kv}"
    {_key, ssid} = List.keyfind(kv, "ssid", 0)
    {_key, psk} = List.keyfind(kv, "psk", 0)
    :ok = NetworkManager.WiFi.write_creds(ssid, psk)
    st = EEx.eval_file(Path.join(:code.priv_dir(:interface), "network_saved.html.eex"), [])
    headers = [
        {"cache-control", "no-cache"},
        {"connection", "close"},
        {"content-type", "text/html"},
        {"expires", "Mon, 3 Jan 2000 12:34:56 GMT"},
        {"pragma", "no-cache"},
        {"Access-Control-Allow-Origin", "*"},
    ]
    {:ok, req3} = :cowboy_req.reply(200, headers, st, req2)
    Nerves.Firmware.reboot
    {:ok, req3, state}
  end

  def error(req, state) do
    st = EEx.eval_file(Path.join(:code.priv_dir(:interface), "network.html.eex"), [error: :invalid_creds])
    headers = [
        {"cache-control", "no-cache"},
        {"connection", "close"},
        {"content-type", "text/html"},
        {"expires", "Mon, 3 Jan 2000 12:34:56 GMT"},
        {"pragma", "no-cache"},
        {"Access-Control-Allow-Origin", "*"},
    ]
    :cowboy_req.reply(200, headers, st, req)
  end

  def terminate(_reason, _req, _state), do: :ok

end
