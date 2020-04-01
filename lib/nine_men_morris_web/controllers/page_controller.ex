defmodule NineMenMorrisWeb.PageController do
  use NineMenMorrisWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
