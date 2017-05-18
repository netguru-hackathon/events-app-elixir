# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

{:ok, org} = Integrator.Repo.insert(%Integrator.Organisation {name: Faker.Company.name})

{:ok, event} = Integrator.Repo.insert(
  %Integrator.Event{
  name: Faker.Company.buzzword,
  organisation_id: org.id,
  description: Faker.Lorem.paragraph}
)

item = %Integrator.Item{
  name: Faker.Company.bs,
  start_time: Ecto.DateTime.cast!(Faker.DateTime.forward(10)),
  end_time: Ecto.DateTime.cast!(Faker.DateTime.forward(11)),
  description: Faker.Lorem.paragraph,
  event_id: event.id}
Integrator.Repo.insert(item)
