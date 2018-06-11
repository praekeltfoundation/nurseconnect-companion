defmodule CompanionWeb.PageControllerTest do
  use CompanionWeb.ConnCase

  test "Login required for /", %{conn: conn} do
    conn = get(conn, "/")
    assert redirected_to(conn, 302) == "/auth/login"
  end

  test "Logged in shows page" do
    conn =
      session_conn()
      |> put_session(:user, %{email: "foo@example.org", provider: :google})
      |> get("/")

    assert html_response(conn, 200) =~ "Welcome to the NurseConnect Companion"
  end
end
