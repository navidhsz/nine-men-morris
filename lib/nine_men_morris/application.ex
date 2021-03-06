defmodule NineMenMorris.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    NineMenMorrisGame.Main.create(:board, :player1, :player2)

    children = [
      # Start the Ecto repository
      # NineMenMorris.Repo,
      # Start the endpoint when the application starts
      NineMenMorrisWeb.Endpoint
      # Starts a worker by calling: NineMenMorris.Worker.start_link(arg)
      # {NineMenMorris.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NineMenMorris.Supervisor]
    Supervisor.start_link(children, opts)

    # FIXEME should be in supervisor and remove hardcoded values
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NineMenMorrisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
