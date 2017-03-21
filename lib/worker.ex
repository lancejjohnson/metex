defmodule Metex.Worker do
  use GenServer

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  def get_stats(pid) do
    GenServer.call(pid, :get_stats)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}°C", new_stats}
      _ ->
        {:reply, :error, stats}
    end
  end

  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  ## Helper Functions

  defp temperature_of(location) do
    location |> Metex.OpenWeather.get |> parse_response()
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true  -> Map.update!(old_stats, location, &(&1 + 1))
      false -> Map.put_new(old_stats, location, 1)
    end
  end

  defp parse_response({:ok, weather_data}) do
    compute_temperature(weather_data)
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end
end
