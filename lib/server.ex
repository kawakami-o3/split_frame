defmodule Server do
  #use Application
  #require Logger

  def read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  def write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
