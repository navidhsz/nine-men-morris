defmodule NineMenMorrisGame.Main do
  @moduledoc """
  NineMenMorris keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use GenServer

  @game __MODULE__

  def create(board_name, player1_name, player2_name) do
    default_player_turn = player1_name
    mill = nil

    GenServer.start_link(
      @game,
      {board_name, player1_name, player2_name, default_player_turn, mill},
      name: @game
    )

    NineMenMorrisGame.State.create(board_name)
    NineMenMorrisGame.Player.create(player1_name, board_name)
    NineMenMorrisGame.Player.create(player2_name, board_name)
  end

  def play(current_player_name, pos) do
    GenServer.call(@game, {:play, current_player_name, nil, pos})
  end

  def play(current_player_name, from_pos, to_pos) do
    GenServer.call(@game, {:play, current_player_name, from_pos, to_pos})
  end

  def remove(current_player_name, pos) do
    GenServer.call(@game, {:remove, current_player_name, pos})
  end

  def get_board_state() do
    NineMenMorrisGame.State.get_board(@game)
  end

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(
        {:play, current_player_name, from_pos, to_pos},
        _from,
        {_board_name, _player1_name, _player2_name, player_turn, mill} = current_state
      )
      when from_pos == nil and player_turn == current_player_name and mill == nil do
    current_player_name
    |> NineMenMorrisGame.Player.move_to_position(to_pos)
    |> get_new_state(current_state, to_pos)
  end

  @impl true
  def handle_call(
        {:play, current_player_name, from_pos, to_pos},
        _from,
        {_board_name, _player1_name, _player2_name, player_turn, mill} = current_state
      )
      when player_turn == current_player_name and mill == nil do
    current_player_name
    |> NineMenMorrisGame.Player.move_to_position(from_pos, to_pos)
    |> get_new_state(current_state, to_pos)
  end

  @impl true
  def handle_call(
        {:play, _current_player_name, _from_pos, _to_pos},
        _from,
        {_board_name, _player1_name, _player2_name, _player_turn, _mill} = current_state
      ) do
    {:reply, {:error, "cannot process :: current_state=#{inspect(current_state)}"}, current_state}
  end

  @impl true
  def handle_call(
        {:remove, current_player_name, pos},
        _from,
        {board_name, player1_name, player2_name, player_turn, mill} = current_state
      )
      when player_turn == current_player_name and mill == current_player_name do
    case get_opponent_player(current_player_name, player1_name, player2_name)
         |> NineMenMorrisGame.Player.remove_opponent_piece(current_player_name, pos) do
      # FIXME :ok should have better message
      {:ok, current_state, new_board} ->
        mill = nil
        next_player = get_opponent_player(current_player_name, player1_name, player2_name)
        new_state = {board_name, player1_name, player2_name, next_player, mill}
        response = construct_response(mill, player_turn, 0, new_board)

        {:reply, {:ok, response}, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  @impl true
  def handle_call(
        {:remove, _current_player_name, _pos},
        _from,
        current_state
      ) do
    {:reply, {:error, "cannot process :: current_state=#{inspect(current_state)}"}, current_state}
  end

  defp get_new_state(result, current_state, to_pos) do
    {board_name, player1_name, player2_name, player_turn, mill} = current_state

    case result do
      {:ok, r, new_board} ->
        {_, _, remaining_pieces, {_, _}} = r

        if NineMenMorrisGame.Logic.mill?(board_name, player_turn, to_pos) == true do
          mill = player_turn
          new_state = {board_name, player1_name, player2_name, player_turn, mill}

          response = construct_response(mill, player_turn, remaining_pieces, new_board)

          {:reply, {:ok, response}, new_state}
        else
          next_player = get_opponent_player(player_turn, player1_name, player2_name)
          new_state = {board_name, player1_name, player2_name, next_player, mill}

          response = construct_response(mill, next_player, remaining_pieces, new_board)

          {:reply, {:ok, response}, new_state}
        end

      {:error, reason} ->
        {:reply, {:error, reason}, current_state}
    end
  end

  defp get_opponent_player(current_player_name, player1_name, player2_name)
       when current_player_name == player1_name do
    player2_name
  end

  defp get_opponent_player(current_player_name, player1_name, player2_name)
       when current_player_name == player2_name do
    player1_name
  end

  defp construct_response(mill, player_turn, remaining_pieces, board) do
    %{
      :mill => mill,
      :playerTurn => player_turn,
      :remainingPieces => remaining_pieces,
      :board => board
    }
  end
end
