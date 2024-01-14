defmodule SpendingCsvTest do
  use ExUnit.Case
  doctest SpendingCsv

  alias SpendingCsv

  describe "parse_entry/1" do
    test "parses a simple entry" do
      entry = "1.00 Groceries"

      assert {"1.00", "Groceries"} = SpendingCsv.parse_entry(entry)
    end

    test "parses an entry with whitespace in description" do
      entry = "12.56 Treats and nice things"

      assert {"12.56", "Treats and nice things"} = SpendingCsv.parse_entry(entry)
    end
  end

  describe "process/1" do
    test "processes a simple example" do
      data = [
        %{"2023-01-01" => ["1.00 Things", "2.00 Stuff"]}
      ]

      assert SpendingCsv.process(data) == [
               {"2023-01-01", "1.00", "Things"},
               {"2023-01-01", "2.00", "Stuff"}
             ]
    end

    test "processes multiple days" do
      data = [
        %{"2023-01-01" => ["1.00 Things", "2.00 Stuff"]},
        %{"2023-01-02" => ["3.00 Something nice"]},
        %{"2023-01-03" => ["4.00 Toys", "5.00 Games"]}
      ]

      assert SpendingCsv.process(data) == [
               {"2023-01-01", "1.00", "Things"},
               {"2023-01-01", "2.00", "Stuff"},
               {"2023-01-02", "3.00", "Something nice"},
               {"2023-01-03", "4.00", "Toys"},
               {"2023-01-03", "5.00", "Games"}
             ]
    end
  end
end
