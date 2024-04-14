defmodule VdPec2Web.Live.Pie do
  use VdPec2Web, :live_view

  # https://github.com/filipecabaco/vegalite_demo
  def mount(_, _, socket) do
    spec =
      VdPec2.Plots.Pie.render_plot()
      |> VegaLite.to_spec()

    socket = assign(socket, id: socket.id)
    {:ok, push_event(socket, "pie_plot:#{socket.id}:init", %{"spec" => spec})}
  end
end
