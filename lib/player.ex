defmodule Player do
  use Agent

  def start_link(name, starting_chips \\ []) do
    Agent.start_link(starting_chips, name: name)
  end

  def draw(pid, n \\ 1) do
    drawn = BowlServer.draw(n)
    Agent.update(pid, &(&1 ++ drawn))
  end

  def get(pid) do
    Agent.get(pid, &(&1))
  end
end