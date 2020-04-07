defmodule NineMenMorrisWeb.GameChannel do
  @moduledoc false

  use Phoenix.Channel

  def join("game:nine-men-morris", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
