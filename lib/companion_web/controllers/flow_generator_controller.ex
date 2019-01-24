defmodule CompanionWeb.FlowGeneratorController do
  use CompanionWeb, :controller

  alias Companion.CompanionWeb

  def index(conn, _params) do
    applications = CompanionWeb.list_applications()
    render(conn, "index.html", applications: applications)
  end

  def create(conn, params) do
    application = CompanionWeb.get_application!(params["application"])

    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("content-disposition", "attachment; filename=send_#{params["date"]}.json")
    # We need to use the `jsonr` extension for the template, else Phoenix stringifys our json
    # before sending it
    |> render("flow.jsonr", %{
      form: params,
      whatsapp_action_id: Ecto.UUID.generate(),
      sms_action_id: Ecto.UUID.generate(),
      rule_set_id: Ecto.UUID.generate(),
      application: application
    })
  end
end
