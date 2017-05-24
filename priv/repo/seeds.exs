# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

{:ok, org} = Integrator.Repo.insert(%Integrator.Organisation {name: Faker.Company.name})

defmodule Integrator.Seeds do
  def create_user do
    Integrator.Repo.insert(
      %Integrator.User{
        first_name: Faker.Name.first_name,
        last_name: Faker.Name.last_name,
        email: Faker.Internet.email,
        avatar_url: Faker.Avatar.image_url |> String.replace("http", "https"),
        slack_team_id: Faker.Code.issn,
        slack_id: Faker.Code.issn
      }
    )
  end

  def create_users(n) when n >= 1 do
    create_user()
    create_users(n - 1)
  end
  def create_users(_), do: create_user()


  def create_event_participation(user, event) do
    Integrator.Repo.insert(
      %Integrator.EventParticipation{
        user_id: user.id,
        event_id: event.id
      }
    )
  end

  def assign_users_to_events do
    events = Integrator.Repo.all(Integrator.Event)
    users = Integrator.Repo.all(Integrator.User)

    for event <- events do
      Enum.each((5..30), fn(_) ->
        create_event_participation(Enum.random(users), event)
      end)
    end
  end

  def create_event(organisation) do
    {:ok, event} = Integrator.Repo.insert(
      %Integrator.Event{
        name: Faker.Company.buzzword,
        organisation_id: organisation.id,
        description: Faker.Lorem.paragraph,
        avatar_url: "https://unsplash.it/200/300?image=#{Enum.random(1..500)}" }
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
        image: "https://unsplash.it/200/300?image=#{Enum.random(501..1084)}",
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
Integrator.Seeds.create_users(100)
Integrator.Seeds.assign_users_to_events
