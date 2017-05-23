defmodule Integrator.Repo.Migrations.AddImageToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :image, :string
    end
  end
end
