use Mix.Config

config :metex, :open_weather_client, Metex.OpenWeather.HttpClient
config :metex, :open_weather_app_id, "0efd074a45a7db913b281c19ec549891"

import_config "#{Mix.env}.exs"
