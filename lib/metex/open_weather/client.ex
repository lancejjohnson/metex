defmodule Metex.OpenWeather.Client do
  @callback get(location :: String.t) :: {:ok, map()}
end
