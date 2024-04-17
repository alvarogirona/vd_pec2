defmodule VdPec2Web.Live.TileGridPlot do
  use VdPec2Web, :live_view

  # https://github.com/filipecabaco/vegalite_demo
  def mount(_, _, socket) do
    spec =
      VdPec2.Plots.Tile.render_plot()
      |> VegaLite.to_spec()

    IO.inspect(spec)

    socket = assign(socket, id: socket.id)
    {:ok, push_event(socket, "tile_grid_plot:#{socket.id}:init", %{"spec" => spec})}
  end
end
