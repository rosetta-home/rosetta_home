defmodule Interface do

  def register do
    GenServer.call(Interface.Client, :register)
  end

end
