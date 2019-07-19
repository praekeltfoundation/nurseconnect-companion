defmodule Companion.Jobs.ProcessOptOutTests do
  use Companion.DataCase

  import Companion.CompanionWeb
  alias Companion.Jobs.ProcessOptOut
  import Tesla.Mock

  @openhim_expected_request %{
                              mha: 1,
                              swt: 1,
                              type: 8,
                              cmsisdn: "+27821234567",
                              dmsisdn: "+27820000000",
                              faccode: "123456",
                              id: "27821234567^^^ZAF^TEL",
                              optoutreason: 6,
                              encdate: "20180530151032",
                              sid: "a49fddb7-cde0-4d3a-aa24-33ecc826f0d2"
                            }

  @rapidpro_contact %{
    results: [
      %{
        urns: ["tel:+27821234567"],
        fields: %{
          registered_by: "+27820000000",
          facility_code: "123456",
          opt_out_date: "2018-05-30T15:10:32.650440Z",
          contact_id: "a49fddb7-cde0-4d3a-aa24-33ecc826f0d2",
        }
      }
    ]
  }

  defp mock_request(response) do
    body = Poison.encode!(response)
    mock(fn
      %{
        method: :get,
        url: "http://rapidpro/api/v2/contacts.json",
        query: [uuid: "a49fddb7-cde0-4d3a-aa24-33ecc826f0d2"],
        headers: [{"authorization", "Token rapidprotoken"}]
      } ->
        json(@rapidpro_contact)

      %{
        method: :post,
        url: "http://openhim/ws/rest/v1/nc/optout",
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

  test "sends opt out to OpenHIM" do
    {:ok, optout} = create_opt_out(%{contact_id: "a49fddb7-cde0-4d3a-aa24-33ecc826f0d2"})
    reg_request = Map.put(@openhim_expected_request, :eid, optout.id)
    mock_request(reg_request)
    ProcessOptOut.run(optout.id)
    optout = get_opt_out!(optout.id)
    assert optout.status == 1
  end

  test "updates error when failure method is run" do
    {:ok, optout} = create_opt_out(%{contact_id: "a49fddb7-cde0-4d3a-aa24-33ecc826f0d2"})
    ProcessOptOut.Failure.handle_failure(%Honeydew.Job{task: {:run, [optout.id]}}, nil, nil)

    optout = get_opt_out!(optout.id)
    assert optout.status == 2
  end
end
