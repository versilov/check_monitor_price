defmodule CheckMonitorPrice do
  @product_url "http://technopoint.ru/product/716a6fcfdb6c3330/27-monitor-lg-27ud68-w-sale/"
  @old_price 30_999

  def check do
    new_price = load_price()
    IO.puts "Current price: #{new_price}"
    if (new_price != @old_price), do: send_sms(new_price)
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

defmodule CheckMonitorPrice.CLI do
  def main(_args) do
    CheckMonitorPrice.check()
  end
end
