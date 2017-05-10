# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

{:ok, org} = Integrator.Repo.insert(%Integrator.Organisation {name: "Netguru"})
event = %Integrator.Event{name: "Hackathon", organisation_id: org.id, description: "Coding & drinking"}
Integrator.Repo.insert(event)
