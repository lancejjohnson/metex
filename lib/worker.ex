defmodule Metex.Worker do
  @doc """
  Function that:

  *   sets up a Worker to be used as a process.
  *   defines the data patterns that the process works with in the `receive`
      block.
  *   recurses on itself so that the process can remain active and receive
      additional messages.

  With this setup the module can be used synchronously within the system

      Metex.Worker.temperature_of("London")

  or asynchronously

      pid = spawn Metex.Worker, :loop, []
      send pid, {self(), "London"}
  """
  def loop do
    receive do
      {sender_pid, location} ->
        send sender_pid, {:ok, temperature_of(location)}
      _ ->
        IO.puts "don't know how to process message."
    end

    loop()
  end

  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |> parse_response
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}C"
      :error ->
        "#{location} not found."
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{api_key()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> IO.inspect |> compute_temperature
  end

  defp parse_response(_), do: :error

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp api_key do
    "0efd074a45a7db913b281c19ec549891"
  end
end
