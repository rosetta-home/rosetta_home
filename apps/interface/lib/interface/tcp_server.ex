defmodule Interface.TCPServer do

  def start_link do
    port = Application.get_env(:interface, :port, "8080") |> String.to_integer
    dispatch = :cowboy_router.compile([
      { :_,
        [
          {"/", Interface.UI.Index, []},
          {"/ui", Interface.UI.V2, []},
          {"/ws", Interface.WebSocketHandler, []},
          {"/floorplan", Interface.UI.Floorplan, []},
          {"/network", Interface.UI.Network, []},
          {"/connect_network", Interface.UI.ConnectNetwork, []},
          {"/reset_network", Interface.UI.ResetNetwork, []},
          {"/app.js", :cowboy_static, {:priv_file, :interface, "app.js"}},
          {"/static/[...]", :cowboy_static, {:priv_dir,  :interface, "static"}},
          {"/build/[...]", :cowboy_static, {:priv_dir,  :interface, "ui/build"}},

        ]}
      ])
      {:ok, _} = :cowboy.start_http(:interface_http,
        5,
        [{:ip, {0,0,0,0}}, {:port, port}],
        [{:env, [{:dispatch, dispatch}]}]
      )
  end


end
