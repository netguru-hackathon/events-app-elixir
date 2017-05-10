defmodule Integrator.EventTest do
  use Integrator.ModelCase

  alias Integrator.Event

  @valid_attrs %{description: Faker.Lorem.paragraph, name: Faker.Company.catch_phrase}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
