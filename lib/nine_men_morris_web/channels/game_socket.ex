defmodule NineMenMorrisWeb.GameSocket do
  @moduledoc false

  use Phoenix.Socket

  channel "game:*", NineMenMorrisWeb.GameChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
