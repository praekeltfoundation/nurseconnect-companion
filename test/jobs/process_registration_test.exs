defmodule Companion.Jobs.ProcessRegistrationTests do
  use Companion.DataCase

  import Companion.CompanionWeb
  alias Companion.Jobs.ProcessRegistration
  import Tesla.Mock

  @registration_request %{
    type: 7,
    sanc: nil,
    rmsisdn: nil,
    persal: nil,
    mha: 6,
    id: "27820001001^^^ZAF^TEL",
    faccode: "123456",
    encdate: "20180101010101",
    dob: nil,
    dmsisdn: "+27820001002",
    cmsisdn: "+27820001001",
    sid: "cdffd588-dc29-469d-b2ac-3a0c2d5d8609"
  }
  @whatsapp_registration_request Map.merge(@registration_request, %{swt: 7})
  @sms_registration_request Map.merge(@registration_request, %{swt: 1})

  defp mock_request(response) do
    body = Poison.encode!(response)

    mock(fn %{
              method: :post,
              url: "http://openhim/ws/rest/v1/nc/subscription",
              headers: [
                {"authorization", "Basic dXNlcjpwYXNz"},
                {"user-agent", "nurseconnect-companion"},
                {"content-type", "application/json"}
              ],
              body: body
            } ->
      json(%{})
    end)

    response
  end

  test "Submits the WhatsApp registration" do
    {:ok, registration} =
      create_registration(%{
        msisdn: "+27820001001",
        registered_by: "+27820001002",
        channel: "WhatsApp",
        facility_code: "123456",
        timestamp: "2018-01-01T01:01:01",
        contact_id: "cdffd588-dc29-469d-b2ac-3a0c2d5d8609"
      })

    reg_request = Map.put(@whatsapp_registration_request, :eid, registration.id)
    mock_request(reg_request)

    ProcessRegistration.run(registration.id)
    :ok
  end

  test "Submits the SMS registration" do
    {:ok, registration} =
      create_registration(%{
        msisdn: "+27820001001",
        registered_by: "+27820001002",
        channel: "SMS",
        facility_code: "123456",
        timestamp: "2018-01-01T01:01:01",
        contact_id: "cdffd588-dc29-469d-b2ac-3a0c2d5d8609"
      })

    reg_request = Map.put(@sms_registration_request, :eid, registration.id)
    mock_request(reg_request)

    ProcessRegistration.run(registration.id)
    :ok
  end
end
