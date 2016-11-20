defmodule Echo do
  #use Application
  require Logger

  def serve(socket) do
    socket
    |> Server.read_line()
    |> Server.write_line(socket)

#serve(socket)
  end

end
