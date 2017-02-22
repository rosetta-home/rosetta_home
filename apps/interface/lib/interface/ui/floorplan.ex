defmodule Interface.UI.Floorplan do
  require Logger

  defmodule State do
    defstruct hostname: nil
  end

  def init({:tcp, :http}, req, opts) do
    {host, req} = :cowboy_req.host(req)
    {:ok, req, %State{:hostname => host }}
  end

  def handle(req, state) do
    Logger.info(System.cwd)
    Logger.info(state.hostname)
    st = EEx.eval_file(Path.join(:code.priv_dir(:interface), "floorplan.html.eex"), [hostname: state.hostname])
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

  def terminate(_reason, req, state), do: :ok

end
