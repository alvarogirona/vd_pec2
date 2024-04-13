defmodule VdPec2Web.Live.Grid do
  use VdPec2Web, :live_view

  # https://github.com/filipecabaco/vegalite_demo
  def mount(_, _, socket) do
    spec =
      VdPec2.Plots.Grid.render_plot()
      |> VegaLite.to_spec()

    socket = assign(socket, id: socket.id)
    {:ok, push_event(socket, "grid_plot:#{socket.id}:init", %{"spec" => spec})}
  end
end
