defmodule Metex.OpenWeatherTest do
  use ExUnit.Case, async: true

  alias Metex.OpenWeather

  test "provides weather data" do
    location = "Wake Forest, North Carolina"
    {:ok, %{"name" => name, "weather" => [weather | _], "main" => main}}
      = OpenWeather.get(location)

    assert name == "Wake Forest"
    assert %{"temp" => _} = main
    assert %{"main" => _, "description" => _} = weather
  end
end

