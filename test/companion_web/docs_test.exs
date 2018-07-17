defmodule Companion.DocsTest do
  use CompanionWeb.ConnCase

  test "returns docs on docs endpoint", %{conn: conn} do
    conn = get(conn, "/api/docs")
    conn = get(conn, redirected_to(conn))

    assert response(conn, :ok) =~ "swagger"
  end
end
