defmodule CompanionWeb.FlowGeneratorControllerTest do
  use CompanionWeb.ConnCase

  alias Companion.CompanionWeb

  @user %{email: "test@example.org", provider: "google"}

  describe "index" do
    test "shows the form for generating flows", %{conn: conn} do
      conn =
        conn
        |> assign(:user, @user)
        |> get(flow_generator_path(conn, :index))

      assert html_response(conn, 200) =~ "<form"
      assert html_response(conn, 200) =~ "Generate Flow</button>"
    end
  end

  describe "create flow generator" do
    test "returns the downloadable json file", %{conn: conn} do
      {:ok, application} = CompanionWeb.create_application(%{name: "some name"})

      conn =
        conn
        |> assign(:user, @user)
        |> post(flow_generator_path(conn, :create), %{
          application: application.id,
          date: "2018-01-01",
          sms: "sms body",
          whatsapp: "whatsapp body"
        })

      [content_disposition_header] = get_resp_header(conn, "content-disposition")
      assert content_disposition_header == "attachment; filename=send_2018-01-01.json"
      response = json_response(conn, 200)
      assert response["site"] == "http://rapidpro"

      assert response
             |> Map.fetch!("flows")
             |> Enum.at(0)
             |> Map.fetch!("action_sets")
             |> Enum.at(0)
             |> Map.fetch!("actions")
             |> Enum.at(1)
             |> Map.fetch!("msg")
             |> Map.fetch!("base") == "sms body"

      assert response
             |> Map.fetch!("flows")
             |> Enum.at(0)
             |> Map.fetch!("action_sets")
             |> Enum.at(1)
             |> Map.fetch!("actions")
             |> Enum.at(1)
             |> Map.fetch!("webhook") ==
               template_message_url(conn, :create, content: "whatsapp body")

      assert response
             |> Map.fetch!("flows")
             |> Enum.at(0)
             |> Map.fetch!("action_sets")
             |> Enum.at(1)
             |> Map.fetch!("actions")
             |> Enum.at(1)
             |> Map.fetch!("webhook_headers")
             |> Enum.at(0)
             |> Map.fetch!("value") == "Token " <> application.token
    end
  end
end
