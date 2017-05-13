defmodule Integrator.Event do
  use Integrator.Web, :model

  schema "events" do
    field :name, :string
    field :description, :string
    belongs_to :organisation, Integrator.Organisation
    has_many :items, Integrator.Item
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
