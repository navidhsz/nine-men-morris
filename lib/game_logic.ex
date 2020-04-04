defmodule GameLogic do
  @moduledoc false

  def do_add(board, player_name, to_pos) do
    case board[to_pos] do
      0 -> {:ok, %{board | to_pos => player_name}}
      ^player_name -> {:error, "already selected by current player (#{player_name})"}
      other_player_name -> {:error, "already selected by #{other_player_name}"}
    end
  end

  def do_move(
        board,
        player_name,
        from_pos,
        to_pos,
        from_pos_state,
        to_pos_state
      ) do
    case can_move(
           board,
           player_name,
           from_pos,
           to_pos,
           from_pos_state,
           to_pos_state
         ) do
      :ok ->
        {:ok, %{%{board | from_pos => 0} | to_pos => player_name}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def can_move(
        board,
        player_name,
        from_pos,
        to_pos,
        from_pos_state,
        to_pos_state
      ) do
    case MovementRules.valid_selection?(player_name, from_pos, from_pos_state) do
      :ok ->
        case MovementRules.valid_destination?(
               player_name,
               to_pos,
               to_pos_state
             ) do
          :ok -> :ok
          {:error, reason} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def mill?(board, player_name, mill_scenario) do
    case mill_scenario
         |> Enum.map(fn [n, m] ->
           board[n] == player_name && board[m] == player_name
         end) do
      [false, false] -> false
      _ -> true
    end
  end
end