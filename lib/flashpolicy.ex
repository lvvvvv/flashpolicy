defmodule FlashPolicy do
	use Application

	@doc false
  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      supervisor(Task.Supervisor, [[name: FlashPolicy.TaskSupervisor]]),
      worker(Task, [FlashPolicy.Server, :accept, [843]])
    ]
    opts = [strategy: :one_for_one, name: FlashPolicy.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
