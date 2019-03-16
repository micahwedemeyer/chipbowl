defmodule Chipbowl do
  alias NimbleCSV.RFC4180, as: CSV

  @runs 50_000

  @player_names [
    "Jordan",
    "Andres",
    "Kevin",
    "Kyle",
    "Christian"
  ]

  @moduledoc """
  Documentation for Chipbowl.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Chipbowl.hello()
      :world

  """
  def setup do
    {:ok, bowl} = BowlServer.start_link()

    players = Enum.map(@player_names, &(Player.start_link(&1, bowl)))
              |> Enum.map(fn({:ok, pid}) -> pid end)

    {players, bowl}
  end

  def run_draw(bowl, players) do
    Enum.each(players, &(Player.draw(&1, 3)))
    BowlServer.refill(bowl)
  end

  def print_csv(players, draws) do
    headers = [
      "Player",
      "Greens",
      "Blues",
      "Reds"
    ]

    rows = Enum.zip([players, @player_names, draws])
    |> Enum.map(fn({_player, name, draw}) -> 
      greens = Keyword.get(draw, :green)
      blues = Keyword.get(draw, :blue)
      reds = Keyword.get(draw, :red)
      [name, greens, blues, reds]
    end)

    CSV.dump_to_iodata([headers] ++ rows)
    |> IO.iodata_to_binary
  end

  def run do
    {players, bowl} = setup()

    (0..@runs - 1)
    |> Enum.each(fn(_) -> run_draw(bowl, players) end)

    drawn = Enum.map(players, &Player.get_as_colors/1)
    csv_str = print_csv(players, drawn)

    {:ok, file} = File.open("cache/results.csv", [:write])
    IO.binwrite(file, csv_str)
    File.close(file)

    IO.inspect(csv_str)
    :ok
  end
end
