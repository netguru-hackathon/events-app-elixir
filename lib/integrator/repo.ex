defmodule Integrator.Repo do
  use Ecto.Repo, otp_app: :integrator
  use Scrivener, page_size: 10
end
