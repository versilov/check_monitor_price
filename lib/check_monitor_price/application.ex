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

  def main(_) do
    # Application.start() will be called for us
    # We just need not to exit, in order to keep GenServer alive.
    :timer.sleep(:infinity)
  end
end
