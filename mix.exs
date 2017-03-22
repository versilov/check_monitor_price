defmodule CheckMonitorPrice.Mixfile do
  use Mix.Project

  def application do
    [extra_applications: [:httpoison],
     mod: {CheckMonitorPrice.Application, []}]
  end

  def project do
    [app: :check_monitor_price,
     version: "1.0.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: CheckMonitorPrice.CLI],
     deps: deps()]
  end

  defp deps do
     [{:httpoison, "~> 0.10.0"},
      {:floki, "~> 0.14.0"}]
  end
end
