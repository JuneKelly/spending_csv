defmodule SpendingCsv do
  @moduledoc """
  Documentation for `SpendingCsv`.
  """

  require Logger

  def main(args) do
    {_flags, [input_path], _errors} = OptionParser.parse(args, strict: [])
    parsed = load_from_file(input_path)
    processed = process(parsed)
    print_csv(processed)
  end

  def load_from_file(path) do
    path
    |> YamlElixir.read_from_file!()
  end

  def process(parsed) do
    Enum.map(parsed, fn date_map ->
      Enum.map(date_map, fn {date, entries} ->
        Enum.map(entries, fn entry ->
          {price, description} = parse_entry(entry)
          {date, price, description}
        end)
      end)
    end)
    |> List.flatten()
  end

  def parse_entry(entry) do
    [^entry, price, description] = Regex.run(~r/([^ ]+) (.*)/, entry)
    {price, description}
  end

  def print_csv(processed) do
    IO.puts("date;cost;description")

    Enum.each(processed, fn {date, price, description} ->
      Enum.join([date, price, description], ";") |> IO.puts()
    end)
  end
end
