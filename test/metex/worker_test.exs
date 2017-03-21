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
end
