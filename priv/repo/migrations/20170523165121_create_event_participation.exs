defmodule Integrator.Repo.Migrations.CreateEventParticipation do
  use Ecto.Migration

  def change do
    create table(:event_participations) do
      add :user_id, references(:users, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end
    create index(:event_participations, [:user_id])
    create index(:event_participations, [:event_id])

  end
end
