defmodule GameLogicTest do
  use ExUnit.Case

  alias GameLogic

  @moduletag :capture_log

  doctest GameLogic

  test "mill detection should return true" do
    player_name = :player1

    board = %{
      %{%{GameDefinitions.get_initial_board() | :a0 => player_name} | :d0 => player_name}
      | :g0 => player_name
    }

    mill_scenario = GameDefinitions.get_possible_mill_scenario(:g0)

    assert GameLogic.mill?(board, player_name, mill_scenario) == true
  end
end
