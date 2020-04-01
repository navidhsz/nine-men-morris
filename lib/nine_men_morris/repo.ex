defmodule NineMenMorris.Repo do
  use Ecto.Repo,
    otp_app: :nine_men_morris,
    adapter: Ecto.Adapters.Postgres
end
