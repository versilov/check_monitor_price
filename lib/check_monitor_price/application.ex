defmodule CheckMonitorPrice.Application do
  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(CheckMonitorPrice.Server, [])
    ]

    opts = [strategy: :one_for_one, name: CheckMonitorPrice.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
