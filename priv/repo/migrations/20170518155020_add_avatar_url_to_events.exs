defmodule Integrator.Repo.Migrations.AddAvatarUrlToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :avatar_url, :string
    end
  end
end
