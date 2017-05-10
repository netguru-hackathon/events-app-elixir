defmodule Integrator.API.EventControllerTest do
  use Integrator.ConnCase

  alias Integrator.Event
  alias Integrator.Organisation

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    org = Repo.insert! %Organisation{name: Faker.Company.name}
    event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}
    other_event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}

    conn = get conn, event_path(conn, :index)
    
    # TODO
    # assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    org = Repo.insert! %Organisation{name: Faker.Company.name}
    event = Repo.insert! %Event{name: Faker.Company.buzzword, description: Faker.Lorem.paragraph, organisation_id: org.id}
    conn = get conn, event_path(conn, :show, event)
    data = json_response(conn, 200)["data"]

    assert data["id"] == "#{event.id}"
    assert data["type"] == "event"
    assert data["attributes"]["name"] == event.name
    assert data["attributes"]["description"] == event.description
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, event_path(conn, :show, -1)
    end
  end
end
