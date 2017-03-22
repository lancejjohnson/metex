defmodule Metex.Worker do
  use GenServer

  @name MW

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [{:name, MW} | opts])
  end

  def get_temperature(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_stats do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats do
    GenServer.cast(@name, :reset_stats)
  end

  def stop do
    GenServer.cast(@name, :stop)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def terminate(reason, state) do
    IO.inspect "Server terminated due to #{inspect reason}.\n" <>
               "Final server state: #{inspect state}"
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

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats}
  end

  # `handle_info/2` is called whenever the server process receives a message
  # for which it has neither a `handle_call/3` or `handle_cast/2` defined.
  def handle_info(msg, state) do
    IO.inspect "Received #{msg}"
    {:noreply, state}
  end

  ## Helper Functions

  defp temperature_of(location) do
    location |> Metex.OpenWeather.get() |> compute_temperature()
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true  -> Map.update!(old_stats, location, &(&1 + 1))
      false -> Map.put_new(old_stats, location, 1)
    end
  end

  defp compute_temperature({:ok, json}) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp compute_temperature(_) do
    :error
  end
end
