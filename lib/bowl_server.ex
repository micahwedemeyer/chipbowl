defmodule BowlServer do
  use GenServer

  @green_idx 0
  @blue_idx 1
  @red_idx 2

  @chip_counts [20, 10, 5]

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def draw(n) do
    GenServer.call(__MODULE__, {:draw, n})
  end

  def init(:ok) do
    {:ok, @chip_counts}
  end

  def handle_call({:draw, n}, _from, chips) do
    {chip_draws, chips} = Bowl.draw_n(chips, n)
    {:reply, chip_draws, chips}
  end
end