defmodule HelloNerves.MixProject do
  use Mix.Project

  @app :hello_nerves
  @version "0.2.0"
  @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :rpi4, :bbb, :osd32mp1, :x86_64]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.13",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {HelloNerves.Application, []},
      extra_applications: [:logger, :runtime_tools, :scenic]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.9", runtime: false},
      {:shoehorn, "~> 0.9.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.1", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi4, "~> 1.20", runtime: false, targets: :rpi4},
      {:scenic, "~> 0.11.1"},
      {:scenic_driver_local, "~> 0.11.0"},
      {:scenic_clock, "~> 0.11.0"},
      {:nerves_time_zones, "~> 0.2.0"},
      # {:scenic_driver_nerves_touch, path: "../scenic_driver_nerves_touch", targets: @all_targets}
      {:scenic_driver_nerves_touch,
       github: "rkenzhebekov/scenic_driver_nerves_touch", branch: "v0.11", targets: :rpi4}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
