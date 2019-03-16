defmodule Chipbowl do
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
    player_names = [
      "Jordan",
      "Andres",
      "Kevin",
      "Kyle",
      "Christian"
    ]

    {:ok, bowl} = BowlServer.start_link()

    players = Enum.map(player_names, &(Player.start_link(&1, bowl)))
              |> Enum.map(fn({:ok, pid}) -> pid end)

    {players, bowl}
  end

  def run_draw(bowl, players) do
    Enum.each(players, &(Player.draw(&1, 3)))
    BowlServer.refill(bowl)
  end

  def run do
    {players, bowl} = setup()

    (0..9999)
    |> Enum.each(fn(_) -> run_draw(bowl, players) end)

    drawn = Enum.map(players, &Player.get_as_colors/1)
    IO.inspect(drawn)
  end
end
