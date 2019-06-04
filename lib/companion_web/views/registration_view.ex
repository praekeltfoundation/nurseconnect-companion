defmodule CompanionWeb.RegistrationView do
  use CompanionWeb, :view
  alias CompanionWeb.RegistrationView

  def render("show.json", %{registration: registration}) do
    render_one(registration, RegistrationView, "registration.json")
  end

  def render("registration.json", %{registration: registration}) do
    %{
      id: registration.id,
      msisdn: registration.msisdn,
      registered_by: registration.registered_by,
      channel: registration.channel,
      facility_code: registration.facility_code,
      persal: registration.persal,
      sanc: registration.sanc,
      timestamp: registration.timestamp
    }
  end
end
