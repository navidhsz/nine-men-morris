defmodule PlayerActor do
  @moduledoc false

  use GenServer

  @game __MODULE__
  @number_of_pieces 9

  def create(player_name, board_name) do
    player_state = {board_name, player_name, @number_of_pieces, {nil, nil}, {nil, nil}}
    GenServer.start_link(@game, player_state, name: player_name)
  end

  def add_to_board({to_pos_x, to_pos_y}, player_name) do
    move = {{nil, nil}, {to_pos_x, to_pos_y}}
    GenServer.call(player_name, {:next_move, move})
  end

  def move_to_position({{from_pos_x, from_pos_y}, {to_pos_x, to_pos_y}}, player_name) do
    move = {{from_pos_x, from_pos_y}, {to_pos_x, to_pos_y}}
    GenServer.call(player_name, {:next_move, move})
  end

  # GenServer implementation

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call(
        {:next_move, {{from_pos_x, from_pos_y}, {to_pos_x, to_pos_y}}},
        _from,
        {board, player_name, remaining_pieces, _, _} = current_state
      )
      when remaining_pieces > 0 do
    case GenServer.call(board, {:add, player_name, {to_pos_x, to_pos_y}}) do
      :ok ->
        new_state =
          {board, player_name, remaining_pieces - 1, {from_pos_x, from_pos_y},
           {to_pos_x, to_pos_y}}

        {:reply, {:ok, new_state}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  def handle_call(
        {:next_move, {{from_pos_x, from_pos_y}, {to_pos_x, to_pos_y}}},
        _from,
        {board, player_name, remaining_pieces, _, _} = current_state
      )
      when remaining_pieces == 0 do
    # todo
    new_state = current_state

    {:reply, {:ok, new_state}, current_state}
  end

  def terminate(_reason, _state) do
    Process.exit(self(), :normal)
  end
end
