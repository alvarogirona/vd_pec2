defmodule VdPec2.Plots.Pie do
  alias VegaLite, as: Vl

  def render_plot() do
    read_csv()
    |> parse_data
    |> vl_from_data()
  end

  defp read_csv() do
    File.stream!(Path.join(:code.priv_dir(:vd_pec2), "/static/datasets/energia_prat.csv"))
    |> CSV.decode!(headers: true)
  end

  defp parse_data(data) do
    data
    |> Enum.map(fn entry ->
      %{
        "qualificacio_energia_acs" => entry["Qualificació energia ACS"],
        "qualificacio_energia_calefaccio" => entry["Qualificació energia calefacció demanda"],
        "qualificacio_co2" => entry["Qualificacio d'emissions de CO2"],
        "qualificacio_energia_refrigeracio" => entry["Qualificació energia refrigeració"]
      }
    end)

    # |> Enum.group_by(fn %{:qualificacio_energia_acs => key} -> key end)
    # |> Enum.map(fn {key, entries} ->
    #   %{
    #     category: key,
    #     count: Enum.count(entries)
    #   }
    # end)
    # |> Enum.filter(fn %{category: category} -> category != "" end)
  end

  defp group_energetic_info(data, key) do
    pie_data =
      data
      |> Enum.group_by(fn %{"qualificacio_energia_acs" => key} -> key end)
      |> Enum.map(fn {key, entries} ->
        %{
          category: key,
          count: Enum.count(entries)
        }
      end)
      |> Enum.filter(fn %{category: category} -> category != "" end)
  end

  defp vl_from_data(pie_data) do
    keys = [
      "qualificacio_energia_acs",
      "qualificacio_energia_calefaccio",
      "qualificacio_co2",
      "qualificacio_energia_refrigeracio"
    ]

    Vl.new()
    |> Vl.concat(
      keys
      |> Enum.map(fn key ->
        selected_data =
          group_entries(pie_data, key)
          |> map_entries()

        Vl.new(title: key)
        |> Vl.data_from_values(selected_data)
        |> Vl.mark(:arc)
        |> Vl.encode_field(:theta, "count", type: :quantitative)
        |> Vl.encode_field(
          :fill,
          "category",
          type: :nominal,
          scale: [scheme: "turbo"]
        )
      end)
    )
  end

  defp group_entries(data, "qualificacio_energia_acs"),
    do: Enum.group_by(data, fn %{"qualificacio_energia_acs" => key} -> key end)

  defp group_entries(data, "qualificacio_energia_calefaccio"),
    do: Enum.group_by(data, fn %{"qualificacio_energia_calefaccio" => key} -> key end)

  defp group_entries(data, "qualificacio_co2"),
    do: Enum.group_by(data, fn %{"qualificacio_co2" => key} -> key end)

  defp group_entries(data, "qualificacio_energia_refrigeracio"),
    do: Enum.group_by(data, fn %{"qualificacio_energia_refrigeracio" => key} -> key end)

  defp map_entries(entries) do
    entries
    |> Enum.map(fn {key, entries} ->
      %{
        category: key,
        count: Enum.count(entries)
      }
    end)
    |> Enum.filter(fn %{category: category} -> category != "" end)
  end
end
