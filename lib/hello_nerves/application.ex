defmodule HelloNerves.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloNerves.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: HelloNerves.Worker.start_link(arg)
        # {HelloNerves.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    viewport_config = Application.get_env(:hello_nerves, :viewport)

    [
      # Children that only run on the host
      # Starts a worker by calling: HelloNerves.Worker.start_link(arg)
      {Scenic, [viewport_config]},
      HelloNerves.Sensors.Supervisor
      # {HelloNerves.Worker, arg}
    ]
  end

  def children(:rpi4) do
    Process.sleep(5000)
    viewport_config = Application.get_env(:hello_nerves, :viewport)

    [
      {Scenic, [viewport_config]},
      HelloNerves.Sensors.Supervisor
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: HelloNerves.Worker.start_link(arg)
      # {HelloNerves.Worker, arg},
    ]
  end

  def target() do
    Application.get_env(:hello_nerves, :target)
  end
end
