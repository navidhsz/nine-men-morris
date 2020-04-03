defmodule GameState do
  @moduledoc false

  use GenServer

  @game __MODULE__

  defp get_initial_board do
    %{
      {"a", 0} => 0,
      {"a", 3} => 0,
      {"a", 6} => 0,
      {"b", 1} => 0,
      {"b", 3} => 0,
      {"b", 5} => 0,
      {"c", 2} => 0,
      {"c", 3} => 0,
      {"c", 4} => 0,
      {"d", 0} => 0,
      {"d", 1} => 0,
      {"d", 4} => 0,
      {"d", 5} => 0,
      {"d", 6} => 0,
      {"e", 2} => 0,
      {"e", 3} => 0,
      {"e", 4} => 0,
      {"f", 1} => 0,
      {"f", 3} => 0,
      {"f", 5} => 0,
      {"g", 0} => 0,
      {"g", 3} => 0,
      {"g", 6} => 0
    }
  end

  def create(name) do
    GenServer.start_link(@game, {get_initial_board(), nil, nil}, name: name)
  end

  def move_to_position({_player, {_pos_x, _pos_y}, name} = new_move) do
    GenServer.call(new_move, name)
  end

  def do_move({board, _player, _pos}) do
    board
  end

  # GenServer implementation

  def init({board, _, _} = _initial_state) do
    {:ok, {board, nil, nil}}
  end

  def handle_call(
        {:next_move, {player, {pos_x, pos_y}}},
        _from,
        {board, _player, _pos} = current_state
      ) do
    new_board = do_move({board, player, {pos_x, pos_y}})
    new_state = {new_board, player, {pos_x, pos_y}}

    new_board |> IO.puts()

    {:reply, new_state, current_state}
  end

  def terminate(_reason, _state) do
    Process.exit(self(), :normal)
  end
end
