defmodule FlashPolicy.Server do

  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    tcp_opts = [:binary, {:reuseaddr, true}, {:nodelay, true}, {:active, false}]
    Logger.info "flash policy server listening on port #{port}"
    {:ok, socket} = :gen_tcp.listen(port, tcp_opts)
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(FlashPolicy.TaskSupervisor, fn -> serve_loop(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve_loop(socket) do
    :inet.setopts(socket, [{:active, :once}])
    receive do
      {:tcp, ^socket, <<"<policy-file-request/>", 0>>} ->
        Logger.info "Got policy-file-request, sending cross domain xml"
        reply = <<"<cross-domain-policy><allow-access-from domain=\"*\" to-ports=\"*\" /></cross-domain-policy>", 0>>
        :gen_tcp.send(socket, reply)
        :gen_tcp.close(socket)
      {:tcp_closed, ^socket} ->
        Logger.info "TCP connection closed"
        :ok
      {:tcp_error, ^socket, reason} ->
        Logger.info "TCP connection errored: #{reason}"
        :ok
      msg ->
        Logger.info "Got invalid message: #{inspect msg}"
        :gen_tcp.close(socket)
    after 5000 ->
      :gen_tcp.close(socket)
    end
  end

end
