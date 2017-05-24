defmodule Integrator.EventParticipation do
  use Integrator.Web, :model

  schema "event_participations" do
    belongs_to :user, Integrator.User
    belongs_to :event, Integrator.Event

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
    |> validate_uniq_participation
  end

  defp validate_uniq_participation(changeset) do
    user_id = get_field(changeset, :user_id)
    event_id = get_field(changeset, :event_id)

    count = Integrator.EventParticipation
      |> where([p], p.user_id == ^user_id and p.event_id == ^event_id )
      |> Integrator.Repo.all
      |> Enum.count

    if count > 0 do
      add_error(changeset, :user_id, "you are already here")
    else
      changeset
    end
  end
end
