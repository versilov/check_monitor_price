defmodule CheckMonitorPrice.Server do
  use GenServer

  @moduledoc """
  Checks for LG 27ud68 monitor price on site technopoint.ru for Samara region
  Every 30 minutes
  Sends SMS if price changes
  Start on remore server with nohup ./check_monitor_price &
  Stop with kill PID, find PID with ps -ef | grep check_monitor_price
  """

  @product_url "http://technopoint.ru/product/716a6fcfdb6c3330/27-monitor-lg-27ud68-w-sale/"
  @check_period 30 # In minutes

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    schedule_work(0) # First check immediately
    {:ok, load_price()}
  end

  defp schedule_work(t) do
    Process.send_after(self(), :check, t * 60 * 1_000)
  end

  def handle_info(:check, price) do
    new_price = load_price()
    IO.puts "Current price: #{new_price}"
    if (new_price != price), do: send_sms(new_price)
    schedule_work(@check_period) #
    {:noreply, new_price}
  end

  defp load_price do
    HTTPoison.get!(@product_url, ["Cookie": "city_path=samara;"]).body
      |> Floki.find("meta[itemprop=\"price\"]")
      |> Floki.attribute("content")
      |> hd
      |> String.to_integer
  end

  defp send_sms(price) do
    HTTPoison.get!(
      "http://api.infosmska.ru/interfaces/SendMessages.ashx",
      ["Connection": "close"],
      params: %{login: "catalyst", pwd: "Ygrnee81",
      phones: "79053042007", message: "27ud68 price: #{price}",
      sender: "ExtraPost"})
        |> IO.inspect
  end
end
