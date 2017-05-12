defmodule Integrator.User do
  use Integrator.Web, :model

  alias Integrator.Repo
  alias Integrator.User

  schema "users" do
    field :slack_id, :string
    field :slack_team_id, :string
    field :email, :string
    field :role, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:slack_id, :slack_team_id, :email, :role, :first_name, :last_name])
    |> validate_required([:slack_id, :slack_team_id, :email])
  end

  def find_or_create_for_slack(params) do
    case Repo.get_by(User, params) do
      nil -> _create_for_slack(params)
      user -> {:ok, user}
    end
  end
  defp _create_for_slack(params) do
    user = %User{}
    |> change(params)
    |> Repo.insert()

    if user.valid?, do: {:ok, user}, else: {:error, user}
  end
end
