defmodule Bowl do
  def draw_n(chips, 1) do
    colors = Enum.count(chips)
    color_drawn = choose_legal(chips, colors)

    decrement_color = fn 
      {chip_count, ^color_drawn} -> chip_count - 1
      {chip_count, _} -> chip_count
    end

    chips = Enum.with_index(chips)
            |> Enum.map(decrement_color)

    {[color_drawn], chips}
  end

  def draw_n(chips, n) when n < 1, do: {nil, chips}

  def draw_n(chips, n) do
    {first_draw, chips} = draw_n(chips, 1)
    {other_draws, chips} = draw_n(chips, n - 1)

    {first_draw ++ other_draws, chips}
  end

  defp choose_legal(chips, colors) do
    boundaries = Enum.scan(chips, 0, &(&1 + &2))
    total_chips = Enum.sum(chips)

    chip_drawn = Enum.random(0..total_chips - 1)

    Enum.find_index(boundaries, &(chip_drawn < &1))
  end
end