defmodule CompanionWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CompanionWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(CompanionWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(CompanionWeb.ErrorView, :"404", %{})
  end
end

defmodule CompanionWeb.FallbackHSMController do
  use CompanionWeb, :controller

  def call(conn, {:error, :bad_request, reason}) do
    conn
    |> put_status(:bad_request)
    |> render(CompanionWeb.HSMView, "error.json", reason: reason)
  end

  def call(conn, {:error, status, reason}) do
    conn
    |> send_resp(status, reason)
  end
end
