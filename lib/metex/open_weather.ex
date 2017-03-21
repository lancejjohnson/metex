defmodule Metex.OpenWeather do
  @client Application.get_env(:metex, :open_weather_client)

  def get(location) do
    location |> @client.get() |> parse_response()
  end

  defp parse_response({:ok, %{body: body, status_code: 200}}) do
    {:ok, JSON.decode!(body)}
  end

  defp parse_response(_), do: :error
end
