defmodule Split do
  use Application
  require Logger

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Task.Supervisor, [[name: Split.TaskSupervisor]]),
      worker(Task, [Split, :accept, [4040]])
    ]

    opts = [strategy: :one_for_one, name: Split.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc false
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                                    [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client_socket} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Split.TaskSupervisor, fn -> serve(client_socket) end)
    :ok = :gen_tcp.controlling_process(client_socket, pid)
    loop_acceptor(socket)
  end

  def serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    Logger.info "hhhhhhh"
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
