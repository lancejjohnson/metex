defmodule Metex do
  def temperatures_of(cities) do
    coordinator = spawn Metex.Coordinator, :loop, [[], Enum.count(cities), self()]

    for city <- cities,
      do: Metex.Worker |> spawn(:loop, []) |> send({coordinator, city})

    receive do
      {:ok, final_results} ->
        IO.inspect final_results |> Enum.join(", "), label: "#{__MODULE__}"
        final_results
      _ ->
        IO.puts "Received message I don't understand"
    end
  end
end
