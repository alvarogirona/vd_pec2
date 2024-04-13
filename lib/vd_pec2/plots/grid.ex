defmodule VdPec2.Plots.Grid do
  alias VegaLite, as: Vl

  def render_plot() do
    read_csv()
    |> group_locations()
    |> render_data()
  end

  defp read_csv() do
    File.stream!(Path.join(:code.priv_dir(:vd_pec2), "/static/datasets/aigua.csv"))
    |> CSV.decode!(headers: true)
    |> Enum.filter(fn %{"Dia" => dia} ->
      [_day, _month, year] = String.split(dia, "/")
      year == "2024"
    end)
  end

  defp group_locations(data) do
    data
    |> Enum.group_by(
      fn elem ->
        elem["Estació"]
      end,
      fn elem ->
        [day, month, year] = String.split(elem["Dia"], "/")

        %{
          :date => Date.from_iso8601!("#{year}-#{month}-#{day}"),
          :absolute_level => elem["Nivell absolut (msnm)"],
          :volume_pct => elem["Percentatge volum embassat (%)"],
          :current_volume => elem["Volum embassat (hm3)"]
        }
      end
    )
  end

  defp render_data(data_by_station) do
    Vl.new(columns: 2)
    |> Vl.concat(
      data_by_station
      |> Enum.map(fn {station_name, data} ->
        Vl.new(width: 350, height: 400, title: station_name)
        |> Vl.data_from_values(data)
        |> Vl.mark(:line)
        |> Vl.encode_field(:x, "date", time_unit: :dayofyear, type: :ordinal)
        |> Vl.encode_field(:y, "volume_pct", type: :quantitative)
      end)
    )
  end
end
