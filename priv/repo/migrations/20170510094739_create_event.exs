defmodule Integrator.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :text
      add :organisation_id, references(:organisations, on_delete: :nothing)

      timestamps()
    end
    create index(:events, [:organisation_id])

  end
end
