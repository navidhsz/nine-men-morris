defmodule GameState do
  @moduledoc false

  use GenServer

  @game __MODULE__
  @number_of_pieces 9

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

  def create(board_name) do
    GenServer.start_link(@game, get_initial_board(), name: board_name)
  end

  def show_board(board_name) do
    GenServer.cast(board_name, :show)
  end

  def do_add(board, player_name, {to_pos_x, to_pos_y}) do
    case board[{to_pos_x, to_pos_y}] do
      0 -> {:ok, %{board | {to_pos_x, to_pos_y} => player_name}}
      player_name -> {:error, "already selected by current player"}
      _ -> {:error, "already selected by other player"}
    end
  end

  # GenServer implementation

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_cast(:show, board) do
    IO.puts(inspect(board))
    {:noreply, board}
  end

  def handle_call(
        {:add, player_name, {to_pos_x, to_pos_y}},
        _from,
        current_board
      ) do
    case do_add(current_board, player_name, {to_pos_x, to_pos_y}) do
      {:ok, new_board} -> {:reply, :ok, new_board}
      {:error, reason} -> {:reply, {:error, reason}, current_board}
    end
  end

  def terminate(_reason, _state) do
    Process.exit(self(), :normal)
  end
end
