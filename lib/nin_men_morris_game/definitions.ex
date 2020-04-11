defmodule NineMenMorrisGame.Definitions do
  @moduledoc false

  def get_initial_board do
    %{
      :a0 => 0,
      :a3 => 0,
      :a6 => 0,
      :b1 => 0,
      :b3 => 0,
      :b5 => 0,
      :c2 => 0,
      :c3 => 0,
      :c4 => 0,
      :d0 => 0,
      :d1 => 0,
      :d2 => 0,
      :d4 => 0,
      :d5 => 0,
      :d6 => 0,
      :e2 => 0,
      :e3 => 0,
      :e4 => 0,
      :f1 => 0,
      :f3 => 0,
      :f5 => 0,
      :g0 => 0,
      :g3 => 0,
      :g6 => 0
    }
  end

  def get_possible_moves(pos) do
    possible_move = %{
      :a0 => [:a3, :d0],
      :a3 => [:a0, :a6, :b3],
      :a6 => [:a3, :d6],
      :b1 => [:b3, :d1],
      :b3 => [:a3, :b1, :b2, :e3],
      :b5 => [:b3, :d5],
      :c2 => [:c3, :e2],
      :c3 => [:c2, :c4, :b3],
      :c4 => [:c3, :d4],
      :d0 => [:a0, :d1, :g0],
      :d1 => [:d0, :b1, :f1],
      :d4 => [:c4, :d5, :e4],
      :d5 => [:d4, :b5, :d6, :f5],
      :d6 => [:d5, :a6, :g6],
      :e2 => [:c2, :e3],
      :e3 => [:e2, :e4, :f3],
      :e4 => [:e3, :d4],
      :f1 => [:f3, :d1],
      :f3 => [:f1, :f5, :e3, :g3],
      :f5 => [:f3, :d5],
      :g0 => [:d0, :g3],
      :g3 => [:g0, :g6, :f3],
      :g6 => [:g3, :d6]
    }

    possible_move[pos]
  end

  def get_possible_mill_scenario(pos) do
    [
      a0: [:a3, :a6],
      a0: [:d0, :g0],
      a3: [:a0, :a6],
      a3: [:b3, :e3],
      a6: [:a0, :a3],
      a6: [:d6, :g6],
      b1: [:d1, :f1],
      b1: [:b3, :b5],
      b3: [:a3, :e3],
      b3: [:b1, :b5],
      b5: [:b1, :b3],
      b5: [:d5, :f5],
      c2: [:d2, :e2],
      c2: [:c3, :c4],
      c3: [:c2, :c4],
      c3: [:a3, :b3],
      c4: [:d4, :e4],
      c4: [:c2, :c3],
      d0: [:a0, :g0],
      d0: [:d1, :d2],
      d1: [:d0, :d2],
      d1: [:b1, :f1],
      d4: [:d5, :d6],
      d4: [:c4, :e4],
      d5: [:d4, :d6],
      d5: [:b5, :f5],
      d6: [:a6, :g6],
      d6: [:d5, :d4],
      e2: [:e3, :e4],
      e2: [:c2, :d2],
      e3: [:e2, :e4],
      e3: [:f3, :g4],
      e4: [:e2, :e3],
      e4: [:c4, :d4],
      f1: [:b1, :d1],
      f1: [:f3, :f5],
      f3: [:e3, :g3],
      f3: [:f1, :f5],
      f5: [:f1, :f3],
      f5: [:b5, :d5],
      g0: [:a0, :d0],
      g0: [:g3, :g6],
      g3: [:e3, :f3],
      g3: [:g0, :g6],
      g6: [:a6, :d6],
      g6: [:g0, :g3]
    ]
    |> Enum.filter(&match?({pos, _}, &1))
    |> Keyword.get_values(pos)
  end
end
