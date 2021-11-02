defmodule GenReport do
  alias GenReport.Parser

  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, acc -> sum(line, acc) end)
  end

  # defp sum([_name, _hours, _day, _month, _year], report), do: report

  defp sum([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = sum_monthly_hours(hours_per_month, name, month, hours)

    hours_per_year = sum_yearly_hours(hours_per_year, name, year, hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_monthly_hours(hours_per_month, name, month, hours) do
    months_map = hours_per_month[name]
    months_map = Map.put(months_map, month, months_map[month] + hours)
    Map.put(hours_per_month, name, months_map)
  end

  defp sum_yearly_hours(hours_per_year, name, year, hours) do
    years_map = hours_per_year[name]
    years_map = Map.put(years_map, year, years_map[year] + hours)
    Map.put(hours_per_year, name, years_map)
  end

  def report_acc do
    names = Enum.into(@names, %{}, &{&1, 0})

    hours = Enum.into(@months, %{}, &{&1, 0})
    hours_per_month = Enum.into(@names, %{}, &{&1, hours})

    years = Enum.into(2016..2020, %{}, &{&1, 0})
    hours_per_year = Enum.into(@names, %{}, &{&1, years})

    build_report(names, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
