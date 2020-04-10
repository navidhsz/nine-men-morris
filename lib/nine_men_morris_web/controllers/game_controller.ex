defmodule NineMenMorrisWeb.GameController do
  @moduledoc false

  use NineMenMorrisWeb, :controller

  def game(conn, _params) do
    render(conn, "game_index.html")
  end
end
