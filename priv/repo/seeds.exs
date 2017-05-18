# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

{:ok, org} = Integrator.Repo.insert(%Integrator.Organisation {name: Faker.Company.name})

defmodule Integrator.Seeds do
  def create_event(organisation) do
    {:ok, event} = Integrator.Repo.insert(
      %Integrator.Event{
        name: Faker.Company.buzzword,
        organisation_id: organisation.id,
        description: Faker.Lorem.paragraph,
        avatar_url: Faker.Avatar.image_url}
    )
    create_items(event, Enum.random(4..10))
  end

  def create_events(organisation, n) when n >= 1 do
    create_event(organisation)
    create_events(organisation, n - 1)
  end

  def create_events(organisation, _n) do
    create_event(organisation)
  end

  def create_item(event) do
    Integrator.Repo.insert(
      %Integrator.Item{
        name: Faker.Company.bs,
        start_time: Ecto.DateTime.cast!(Faker.DateTime.forward(10)),
        end_time: Ecto.DateTime.cast!(Faker.DateTime.forward(11)),
        description: Faker.Lorem.paragraph,
        event_id: event.id}
    )
  end

  def create_items(event, n) when n >= 1 do
    create_item(event)
    create_items(event, n - 1)
  end

  def create_items(event, _n) do
    create_item(event)
  end
end

Integrator.Seeds.create_events(org, 15)
