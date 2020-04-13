defmodule NineMenMorrisWeb.GameChannel do
  @moduledoc false

  use Phoenix.Channel

  def join("game:nine-men-morris", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("remove", message, socket) do
    action = message["action"]
    position = message["position"] |> String.to_atom()
    player_name = message["playerName"] |> String.to_atom()

    case NineMenMorrisGame.Main.remove(player_name, position) do
      {:ok, response} ->
        update_other_player_remove(socket, player_name, position, response[:board])
        {:reply, {:ok, response}, socket}

      {:error, reason} ->
        {:reply, {:error, %{:reason => reason}}, socket}
    end
  end

  def handle_in("move", message, socket) do
    action = message["action"]
    from_pos = message["fromPosition"] |> String.to_atom()
    to_pos = message["toPosition"] |> String.to_atom()
    player_name = message["playerName"] |> String.to_atom()

    IO.puts("move ================")

    case NineMenMorrisGame.Main.play(player_name, from_pos, to_pos) do
      {:ok, response} ->
        update_other_player_move(socket, player_name, from_pos, to_pos, response[:board])
        {:reply, {:ok, response}, socket}

      {:error, reason} ->
        {:reply, {:error, %{:reason => reason}}, socket}
    end
  end

  def handle_in("add", message, socket) do
    action = message["action"]
    position = message["position"] |> String.to_atom()
    player_name = message["playerName"] |> String.to_atom()

    IO.puts("add ================")

    case NineMenMorrisGame.Main.play(player_name, position) do
      {:ok, response} ->
        update_other_player_add(socket, player_name, position, response[:board])
        {:reply, {:ok, response}, socket}

      {:error, reason} ->
        {:reply, {:error, %{:reason => reason}}, socket}
    end
  end

  defp update_other_player_add(socket, player_name, position, board) do
    broadcast_from(socket, "update_board_position_add", %{
      :playerName => player_name,
      :position => position,
      :board => board,
      :log => "#{player_name} moved to position '#{position}'"
    })
  end

  defp update_other_player_move(socket, player_name, from_pos, to_pos, board) do
    broadcast_from(socket, "update_board_position_move", %{
      :playerName => player_name,
      :from_pos => from_pos,
      :to_pos => to_pos,
      :board => board,
      :log => "#{player_name} moved from '#{from_pos}' to position '#{to_pos}'"
    })
  end

  defp update_other_player_remove(socket, player_name, position, board) do
    broadcast_from(socket, "update_board_position_remove", %{
      :playerName => player_name,
      :position => position,
      :board => board,
      :log => "#{player_name} removed a piece from position '#{position}'"
    })
  end
end
