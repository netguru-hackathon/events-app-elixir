# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

{:ok, org} = Integrator.Repo.insert(%Integrator.Organisation {name: Faker.Company.name})
event = %Integrator.Event{name: Faker.Company.buzzword, organisation_id: org.id, description: Faker.Lorem.paragraph}
Integrator.Repo.insert(event)
