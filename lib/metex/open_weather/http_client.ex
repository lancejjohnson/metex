defmodule Metex.OpenWeather.HttpClient do
  @behaviour Metex.OpenWeather.Client

  @app_id Application.get_env(:metex, :open_weather_app_id)

  def get(location) do
    location |> url_for() |> get_data()
  end

  defp url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{@app_id}"
  end

  defp get_data(url) do
    HTTPoison.get(url)
  end
end

