defmodule Integrator.Item do
  use Integrator.Web, :model

  schema "items" do
    field :name, :string
    field :start_time, Ecto.DateTime
    field :end_time, Ecto.DateTime
    field :description, :string
    field :image, :string
    belongs_to :event, Integrator.Event

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :start_time, :end_time, :description])
    |> validate_required([:name, :start_time, :end_time, :description])
  end
end
