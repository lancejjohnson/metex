defmodule Metex.Coordinator do
  @moduledoc """
  Sets up an actor that keeps track of how many results are expected to be
  received. If the coordinator has not received the expected amount of results,
  it recurses to stay alive to receive other messages. When the expected amount
  is reached, it exits and prints the results.
  """
  def loop(results \\ [], results_expected, parent \\ nil) do
    receive do
      {:ok, result} ->
        new_results = [result | results]
        if results_expected == Enum.count(new_results), do: send self(), :exit
        loop new_results, results_expected, parent
      :exit -> # NOTA BENE: nothing special about :exit, could be anything
        sorted_results = results |> Enum.sort
        send parent, {:ok, sorted_results}
      _ ->
        loop results, results_expected, parent
    end
  end
end
