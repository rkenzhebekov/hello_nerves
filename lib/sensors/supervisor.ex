# a simple supervisor that starts up the Scenic.SensorPubSub server
# and any set of other sensor processes

defmodule HelloNerves.Sensors.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    [
      HelloNerves.Sensors.Temperature
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
