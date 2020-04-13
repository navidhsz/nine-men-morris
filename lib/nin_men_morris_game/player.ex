defmodule NineMenMorrisGame.Player do
  @moduledoc false

  use GenServer

  @game __MODULE__
  @number_of_pieces 3

  def create(player_name, board_name) do
    player_state = {board_name, player_name, @number_of_pieces, {nil, nil}}
    GenServer.start_link(@game, player_state, name: player_name)
  end

  def move_to_position(player_name, to_pos) do
    GenServer.call(player_name, {:next_move, {nil, to_pos}})
  end

  def move_to_position(player_name, from_pos, to_pos) do
    GenServer.call(player_name, {:next_move, {from_pos, to_pos}})
  end

  def remove_opponent_piece(other_player_name, player_name, pos) do
    GenServer.call(player_name, {:remove, pos, other_player_name})
  end

  # GenServer implementation
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(
        {:remove, pos, other_player_name},
        _from,
        {board, player_name, _remaining_pieces, _} = current_state
      ) do
    case GenServer.call(board, {:remove, player_name, pos, other_player_name}) do
      {:ok, new_board} ->
        {:reply, {:ok, current_state, new_board}, current_state}

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  @impl true
  def handle_call(
        {:next_move, {nil, _to_pos}},
        _from,
        {_, _, remaining_pieces, _} = current_state
      )
      when remaining_pieces == 0 do
    {:reply, {:error, "all the pieces are on the board. start moving the pieces"}, current_state}
  end

  @impl true
  def handle_call(
        {:next_move, {from_pos, to_pos}},
        _from,
        {board, player_name, remaining_pieces, _} = current_state
      )
      when remaining_pieces > 0 do
    case GenServer.call(board, {:add, player_name, to_pos}) do
      {:ok, new_board} ->
        new_state = {board, player_name, remaining_pieces - 1, {from_pos, to_pos}}

        {:reply, {:ok, new_state, new_board}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  @impl true
  def handle_call(
        {:next_move, {from_pos, to_pos}},
        _from,
        {board, player_name, remaining_pieces, _} = current_state
      )
      when remaining_pieces == 0 do
    case GenServer.call(board, {:move, player_name, from_pos, to_pos}) do
      {:ok, new_board} ->
        new_state = {board, player_name, remaining_pieces, {from_pos, to_pos}}
        {:reply, {:ok, new_state, new_board}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  @impl true
  def terminate(_reason, _state) do
    Process.exit(self(), :normal)
  end
end
