defmodule Companion.ApiRootControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb.Application

  @application %Application{name: "test", token: Ecto.UUID.generate()}

  test "returns empty response for root", %{conn: conn} do
    conn =
      conn
      |> assign(:application, @application)
      |> get(api_root_path(conn, :index))

    assert json_response(conn, :ok) == %{}
  end

  test "returns 401 response for root if not authenticated", %{conn: conn} do
    conn =
      conn
      |> get(api_root_path(conn, :index))

    assert response(conn, :unauthorized) == ""
  end
end
