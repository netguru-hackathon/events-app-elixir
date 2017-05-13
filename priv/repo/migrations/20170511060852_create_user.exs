defmodule Integrator.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :slack_id, :string
      add :slack_team_id, :string
      add :email, :string
      add :role, :string
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

  end
end
