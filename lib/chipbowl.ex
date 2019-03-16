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

  def run do
    {players, bowl} = setup()

    Enum.each(players, &(Player.draw(&1, 3)))

    drawn = Enum.map(players, &Player.get_as_colors/1)
    IO.inspect(drawn)
    IO.inspect(BowlServer.get_chips(bowl))
  end
end
