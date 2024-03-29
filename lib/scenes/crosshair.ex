defmodule HelloNerves.Scene.Crosshair do
  use Scenic.Scene

  alias Scenic.Graph
  alias Scenic.Primitive
  import Scenic.Primitives

  alias HelloNerves.Component.Nav
  require Logger

  @width 10000
  @height 10000

  @input_classes [:cursor_button, :cursor_scroll, :cursor_pos]

  @graph Graph.build(font: :roboto, font_size: 16)
         |> rect({@width, @height}, id: :background, input: @input_classes)
         |> text("Touch the screen to start", id: :pos, translate: {21, 80})
         |> line({{0, 100}, {@width, 100}}, stroke: {4, :white}, id: :cross_hair_h, hidden: true)
         |> line({{100, 0}, {100, @height}}, stroke: {4, :white}, id: :cross_hair_v, hidden: true)
         |> Nav.add_to_graph(__MODULE__)

  # ============================================================================
  # setup

  # --------------------------------------------------------
  @impl Scenic.Scene
  def init(scene, _, _) do
    scene =
      scene
      |> assign(graph: @graph)
      |> push_graph(@graph)

    # :ok = request_input(scene, @input_classes)
    {:ok, scene}
  end

  # ============================================================================
  # event handlers

  # --------------------------------------------------------
  def handle_input({:cursor_pos, {x, y}}, _context, %{assigns: %{graph: graph}} = scene) do
    IO.inspect({x, y}, label: "Input - cursor_pos")
    Logger.info("Input - cursor_pos {#{x}, #{y}")

    graph =
      graph
      |> Graph.modify(:cross_hair_h, fn p ->
        p
        |> Primitive.put({{0, y}, {@width, y}})
      end)
      |> Graph.modify(:cross_hair_v, fn p ->
        p
        |> Primitive.put({{x, 0}, {x, @height}})
      end)
      |> Graph.modify(:pos, fn p ->
        Primitive.put(
          p,
          "x: #{:erlang.float_to_binary(x * 1.0, decimals: 1)}, y: #{:erlang.float_to_binary(y * 1.0, decimals: 1)}"
        )
      end)

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_input(
        {:cursor_button, {:btn_left, 1, _, {x, y}}},
        _context,
        %{assigns: %{graph: graph}} = scene
      ) do
    IO.inspect({x, y}, label: "Input - btn_left - pressed")
    Logger.info("Input - cursor_button {#{x}, #{y} - pressed")

    graph =
      graph
      |> Graph.modify(:cross_hair_h, fn p ->
        p
        |> Primitive.put({{0, y}, {@width, y}})
        |> Primitive.put_style(:hidden, false)
      end)
      |> Graph.modify(:cross_hair_v, fn p ->
        p
        |> Primitive.put({{x, 0}, {x, @height}})
        |> Primitive.put_style(:hidden, false)
      end)
      |> Graph.modify(:pos, fn p ->
        Primitive.put(
          p,
          "x: #{:erlang.float_to_binary(x * 1.0, decimals: 1)}, y: #{:erlang.float_to_binary(y * 1.0, decimals: 1)}"
        )
      end)

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_input(
        {:cursor_button, {:btn_left, 0, _, {x, y}}},
        _context,
        %{assigns: %{graph: graph}} = scene
      ) do
    IO.inspect({x, y}, label: "Input - btn_left - released")
    Logger.info("Input - cursor_button {#{x}, #{y}} - released")

    graph =
      Graph.modify(graph, :cross_hair_h, fn p ->
        Primitive.put_style(p, :hidden, true)
      end)

    graph =
      Graph.modify(graph, :cross_hair_v, fn p ->
        Primitive.put_style(p, :hidden, true)
      end)
      |> Graph.modify(:pos, fn p ->
        Primitive.put(
          p,
          "x: #{:erlang.float_to_binary(x * 1.0, decimals: 1)}, y: #{:erlang.float_to_binary(y * 1.0, decimals: 1)}"
        )
      end)

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  @impl Scenic.Scene
  def handle_input(evt, _ctx, scene) do
    IO.inspect({evt, scene}, label: "Input: ")
    Logger.info("unhandled Input - ")
    {:noreply, scene}
  end
end
