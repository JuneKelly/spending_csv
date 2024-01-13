defmodule SpendingCsv do
  @moduledoc """
  Documentation for `SpendingCsv`.
  """

  require Logger

  def run() do
    [input_path] = System.argv()

    Logger.info("Loading from #{input_path}")
  end

  def load_from_file(path) do
    path
    |> YamlElixir.read_from_file!()
  end

  def parse_entry(entry) do
    [^entry, price, description] = Regex.run(~r/([^ ]+) (.*)/, entry)
    {price, description}
  end
end
