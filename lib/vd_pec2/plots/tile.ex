defmodule VdPec2.Plots.Tile do
  alias VegaLite, as: Vl

  def render_plot() do
    read_data()
    |> parse_data()
    |> render_data()
  end

  defp read_data() do
    File.stream!(Path.join(:code.priv_dir(:vd_pec2), "/static/datasets/periodic_table.csv"))
    |> CSV.decode!(headers: true)
  end

  defp parse_data(data) do
    data
    |> Enum.map(fn entry ->
      %{
        "name" => entry["name"],
        "xpos" => entry["xpos"],
        "ypos" => entry["ypos"],
        "wxpos" => entry["wxpos"],
        "wypos" => entry["wypos"],
        "symbol" => entry["symbol"],
        "color" => "##{entry["cpk-hex"]}"
      }
    end)
  end

  defp colors_from_data(data) do
    data
    |> Enum.map(fn entry ->
      entry["color"]
    end)
  end

  defp render_data(data) do
    colors = colors_from_data(data)

    Vl.new(width: 1800, height: 1000)
    |> Vl.config(
      axis: [
        grid: false,
        domain: false,
        labels: false,
        ticks: false,
        title: false
      ]
    )
    |> Vl.data_from_values(data)
    |> Vl.encode_field(:x, "xpos", type: :quantitative)
    |> Vl.encode_field(:y, "ypos", type: :quantitative, sort: :descending)
    |> Vl.encode_field(:text, "symbol", type: :nominal)
    |> Vl.layers([
      Vl.new()
      |> Vl.mark(:square, size: 8000, stroke: :black, strokeWidth: 1)
      |> Vl.encode_field(:color, "color",
        legend: nil,
        scale: [domain: colors, range: colors]
      ),
      Vl.new()
      |> Vl.mark(:text, fill: :black, fontWeight: "bold")
      |> Vl.encode_field(:text, "symbol", type: :nominal)
      |> Vl.encode(:size, value: 19),
      Vl.new()
      |> Vl.mark(:text, dy: 20, fill: :black)
      |> Vl.encode_field(:text, "name", type: :nominal, padding: 20)
      |> Vl.encode(:size, value: 13)
    ])
  end
end
