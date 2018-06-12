defmodule CompanionWeb.ApplicationController do
  use CompanionWeb, :controller

  alias Companion.CompanionWeb
  alias Companion.CompanionWeb.Application

  def index(conn, _params) do
    applications = CompanionWeb.list_applications()
    changeset = CompanionWeb.change_application(%Application{})
    render(conn, "index.html", applications: applications, changeset: changeset)
  end

  def create(conn, %{"application" => application_params}) do
    case CompanionWeb.create_application(application_params) do
      {:ok, _application} ->
        conn
        |> put_flash(:info, "Application created successfully.")
        |> redirect(to: application_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        applications = CompanionWeb.list_applications()
        render(conn, "index.html", applications: applications, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = CompanionWeb.get_application!(id)
    {:ok, _application} = CompanionWeb.delete_application(application)

    conn
    |> put_flash(:info, "Application deleted successfully.")
    |> redirect(to: application_path(conn, :index))
  end
end
