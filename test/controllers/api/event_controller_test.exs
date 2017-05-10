defmodule Integrator.API.EventControllerTest do
  use Integrator.ConnCase

  alias Integrator.Event
  alias Integrator.Organisation

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    org = Repo.insert! %Organisation{name: Faker.Company.name}
    event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}
    other_event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}

    conn = get conn, event_path(conn, :index)
    assert json_response(conn, 200)["data"] == [%{"id" => event.id, "name" => event.name}, %{"id" => other_event.id, "name" => other_event.name}]
  end

  test "shows chosen resource", %{conn: conn} do
    org = Repo.insert! %Organisation{name: Faker.Company.name}
    event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}
    conn = get conn, event_path(conn, :show, event)
    assert json_response(conn, 200)["data"] == %{"id" => event.id, "name" => event.name}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, event_path(conn, :show, -1)
    end
  end
end
