defmodule Metex.WorkerTest do
  use ExUnit.Case, async: true

  alias Metex.Worker

  setup do
    {:ok, _} = Worker.start_link
    :ok
  end


  test "gets the temperature for a location" do
    temp = Worker.get_temperature("Wake Forest, NC")
    assert temp =~ ~r/\d+°C/
  end

  test "resetting the state of the server" do
     temp = Worker.get_temperature("Wake Forest, NC")
     before = Worker.get_stats
     :ok = Worker.reset_stats

     refute before == Worker.get_stats
  end

  test "stopping the server" do
    assert :ok == Worker.stop
  end
end
