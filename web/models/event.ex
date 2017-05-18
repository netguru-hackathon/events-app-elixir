defmodule Integrator.Event do
  use Integrator.Web, :model

  schema "events" do
    field :name, :string
    field :description, :string
    field :avatar_url, :string
    belongs_to :organisation, Integrator.Organisation
    has_many :items, Integrator.Item
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :avatar_url])
    |> validate_required([:name, :description])
  end
end
