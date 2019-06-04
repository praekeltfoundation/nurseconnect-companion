defmodule CompanionWeb.RegistrationController do
  use CompanionWeb, :controller

  alias CompanionWeb.FallbackController

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.Registration

  action_fallback FallbackController

  def create(conn, %{}) do
    conn = conn |> fetch_query_params()

    with {:ok, %Registration{} = registration} <-
           CompanionWeb.create_registration(conn.query_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", registration_path(conn, :show, registration))
      |> render("show.json", registration: registration)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = CompanionWeb.get_registration!(id)
    render(conn, "show.json", registration: registration)
  end
end
