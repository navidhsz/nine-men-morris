defmodule NineMenMorrisWeb.GameChannel do
  @moduledoc false

  use Phoenix.Channel

  def join("game:nine-men-morris", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("add", message, socket) do
    action = message["action"]
    position = message["position"] |> String.to_atom()
    player_name = message["playerName"] |> String.to_atom()
    IO.puts("add ================")

    case NineMenMorrisGame.Main.play(player_name, position) do
      {:ok, _r} -> {:reply, :ok, socket}
      :ok -> {:reply, :ok, socket}
      {:error, reason} -> {:reply, {:error, %{:reason => reason}}, socket}
    end
  end
end
