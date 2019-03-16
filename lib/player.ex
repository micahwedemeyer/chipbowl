defmodule Player do
  use Agent

  def start_link(name, bowl, starting_chips \\ []) do
    Agent.start_link(fn -> {starting_chips, bowl} end, name: {:global, name})
  end

  def draw(pid, n \\ 1) do
    Agent.update(pid, fn({chips, bowl}) ->
      drawn = BowlServer.draw(bowl, n)
      {chips ++ drawn, bowl}
    end)
  end

  def get_chips(pid) do
    Agent.get(pid, fn({chips, bowl}) -> chips end)
  end

  def get_as_colors(pid) do
    chips = get_chips(pid)

    greens = Enum.count(chips, &(&1 == 0))
    blues = Enum.count(chips, &(&1 == 1))
    reds = Enum.count(chips, &(&1 == 2))

    [
      green: greens,
      blue: blues,
      red: reds
    ]
  end
end