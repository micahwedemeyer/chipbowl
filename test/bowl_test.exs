defmodule BowlTest do
  use ExUnit.Case

  test "draws the right number of chips" do
  	# Force a seed so random draws are predictable
  	:rand.seed(:exsplus, {102, 101, 103})

  	chips = [
  		20,
  		10,
  		5
  	]

  	{drawn, chips} = Bowl.draw_n(chips, 3)

    assert drawn == [1, 0, 0]
    assert chips == [18, 9, 5]
  end
end
