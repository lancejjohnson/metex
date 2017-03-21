defmodule Metex.OpenWeather.TestClient do
  @behaviour Metex.OpenWeather.Client

  def get(_location) do
    {:ok, %{body: get_data(), status_code: 200}}
  end

  defp get_data(_ \\ nil) do
    """
    {
      "coord": {
        "lon": -78.51,
        "lat": 35.98
      },
      "weather": [
        {
          "id": 800,
          "main": "Clear",
          "description": "clear sky",
          "icon": "01d"
        }
      ],
      "base": "stations",
      "main": {
        "temp": 298.05,
        "pressure": 1013,
        "humidity": 38,
        "temp_min": 294.15,
        "temp_max": 301.15
      },
      "visibility": 16093,
      "wind": {
        "speed": 2.6,
        "deg": 290
      },
      "clouds": {
        "all": 1
      },
      "dt": 1490123760,
      "sys": {
        "type": 1,
        "id": 1798,
        "message": 0.0099,
        "country": "US",
        "sunrise": 1490094878,
        "sunset": 1490138854
      },
      "id": 4497290,
      "name": "Wake Forest",
      "cod": 200
    }
    """
  end
end
