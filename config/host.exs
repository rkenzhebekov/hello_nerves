import Config

# Add configuration that is only needed when running on the host here.

config :hello_nerves, :viewport,
  name: :main_viewport,
  size: {800, 600},
  theme: :dark,
  default_scene: HelloNerves.Scene.Components,
  drivers: [
    [
      module: Scenic.Driver.Local,
      name: :local,
      window: [resizeable: false, title: "hello_nerves"],
      on_close: :stop_system
    ]
  ]
