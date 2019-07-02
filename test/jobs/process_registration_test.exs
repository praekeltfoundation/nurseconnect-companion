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
    cmsisdn: "+27820001001"
  }
  @whatsapp_registration_request Poison.encode!(Map.merge(@registration_request, %{swt: 7}))
  @sms_registration_request Poison.encode!(Map.merge(@registration_request, %{swt: 1}))

  defp mock_request(response) do
    mock(fn
      %{
        method: :post,
        url: "http://openhim/ws/rest/v1/nc/subscription",
        headers: [
          {"authorization", "Basic dXNlcjpwYXNz"},
          {"user-agent", "nurseconnect-companion"},
          {"content-type", "application/json"}
        ],
        body: ^response
      } ->
        json(%{})
    end)

    response
  end

  test "Submits the WhatsApp registration" do
    mock_request(@whatsapp_registration_request)

    {:ok, registration} =
      create_registration(%{
        msisdn: "+27820001001",
        registered_by: "+27820001002",
        channel: "WhatsApp",
        facility_code: "123456",
        timestamp: "2018-01-01T01:01:01"
      })

    ProcessRegistration.run(registration.id)
    :ok
  end

  test "Submits the SMS registration" do
    mock_request(@sms_registration_request)

    {:ok, registration} =
      create_registration(%{
        msisdn: "+27820001001",
        registered_by: "+27820001002",
        channel: "SMS",
        facility_code: "123456",
        timestamp: "2018-01-01T01:01:01"
      })

    ProcessRegistration.run(registration.id)
    :ok
  end
end
