defmodule NineMenMorrisGame.State do
  @moduledoc false

  use GenServer

  @game __MODULE__

  def create(board_name) do
    GenServer.start_link(@game, NineMenMorrisGame.Definitions.get_initial_board(),
      name: board_name
    )
  end

  def show_board(board_name) do
    GenServer.cast(board_name, :show)
  end

  def get_board(board_name) do
    GenServer.call(board_name, :get_board)
  end

  defp process_add(board, player_name, to_pos) do
    NineMenMorrisGame.Logic.do_add(board, player_name, to_pos)
  end

  defp process_move(board, player_name, from_pos, to_pos) do
    from_pos_state = board[from_pos]
    to_pos_state = board[to_pos]

    NineMenMorrisGame.Logic.do_move(
      board,
      player_name,
      from_pos,
      to_pos,
      from_pos_state,
      to_pos_state
    )
  end

  defp process_remove(board, player_name, pos, other_player_name, value_at_pos)
       when value_at_pos == other_player_name do
    {:ok, %{board | pos => 0}}
  end

  defp process_remove(board, player_name, pos, other_player_name, value_at_pos)
       when value_at_pos == 0 do
    {:error, "position=#{pos} is empty. nothing to delete"}
  end

  defp process_remove(board, player_name, pos, other_player_name, value_at_pos)
       when value_at_pos == player_name do
    {:error, "position=#{pos} has current player piece. cannot delete"}
  end

  # GenServer implementation

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_cast(:show, board) do
    IO.puts(inspect(board))
    {:noreply, board}
  end

  @impl true
  def handle_call(
        :get_board,
        _from,
        current_board
      ) do
    {:reply, current_board, current_board}
  end

  @impl true
  def handle_call(
        {:remove, player_name, pos, other_player_name},
        _from,
        current_board
      ) do
    case process_remove(current_board, player_name, pos, other_player_name, current_board[pos]) do
      # TODO should check the mill
      {:ok, new_board} -> {:reply, {:ok, new_board}, new_board}
      {:error, reason} -> {:reply, {:error, reason}, current_board}
    end
  end

  @impl true
  def handle_call(
        {:add, player_name, to_pos},
        _from,
        current_board
      ) do
    case process_add(current_board, player_name, to_pos) do
      {:ok, new_board} -> {:reply, {:ok, new_board}, new_board}
      {:error, reason} -> {:reply, {:error, reason}, current_board}
    end
  end

  @impl true
  def handle_call(
        {:move, player_name, from_pos, to_pos},
        _from,
        current_board
      ) do
    case process_move(current_board, player_name, from_pos, to_pos) do
      {:ok, new_board} -> {:reply, {:ok, new_board}, new_board}
      {:error, reason} -> {:reply, {:error, reason}, current_board}
    end
  end
end
