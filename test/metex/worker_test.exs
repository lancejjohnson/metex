defmodule Metex.WorkerTest do
  use ExUnit.Case, async: true

  alias Metex.Worker

  setup do
    {:ok, worker} = Worker.start_link
    {:ok, worker: worker}
  end


  test "gets the temperature for a location", %{worker: worker} do
    temp = Worker.get_temperature(worker, "Wake Forest, NC")
    assert temp =~ ~r/\d+°C/
  end

  test "resetting the state of the server", %{worker: worker} do
     temp = Worker.get_temperature(worker, "Wake Forest, NC")
     before = Worker.get_stats(worker)
     :ok = Worker.reset_stats(worker)

     refute before == Worker.get_stats(worker)
  end

  test "stopping the server", %{worker: worker} do
    assert :ok == Worker.stop(worker)
  end
end
