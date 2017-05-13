defmodule Integrator.Repo.Migrations.CreateItem do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :description, :text
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end
    create index(:items, [:event_id])

  end
end
