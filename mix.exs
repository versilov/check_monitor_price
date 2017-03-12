defmodule CheckMonitorPrice.Mixfile do
  use Mix.Project

  def application do
    [applications: [:httpoison]]
  end

  def project do
    [app: :check_monitor_price,
     version: "1.0.0",
     elixir: "~> 1.4",
     deps: deps()]
  end

  defp deps do
     [{:httpoison, "~> 0.10.0"},
      {:floki, "~> 0.14.0"}]
  end
end
