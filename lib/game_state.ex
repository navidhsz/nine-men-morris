defmodule GameState do
  @moduledoc false

  use GenServer

  @game __MODULE__
  @number_of_pieces 9

  def create(board_name) do
    GenServer.start_link(@game, GameDefinitions.get_initial_board(), name: board_name)
  end

  def show_board(board_name) do
    GenServer.cast(board_name, :show)
  end

  defp process_add(board, player_name, to_pos) do
    GameLogic.do_add(board, player_name, to_pos)
  end

  defp process_move(board, player_name, from_pos, to_pos) do
    from_pos_state = board[from_pos]
    to_pos_state = board[to_pos]

    GameLogic.do_move(
      board,
      player_name,
      from_pos,
      to_pos,
      from_pos_state,
      to_pos_state
    )
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
        {:add, player_name, to_pos},
        _from,
        current_board
      ) do
    case process_add(current_board, player_name, to_pos) do
      {:ok, new_board} -> {:reply, :ok, new_board}
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
      {:ok, new_board} -> {:reply, :ok, new_board}
      {:error, reason} -> {:reply, {:error, reason}, current_board}
    end
  end

  @impl true
  def terminate(_reason, _state) do
    Process.exit(self(), :normal)
  end
end
