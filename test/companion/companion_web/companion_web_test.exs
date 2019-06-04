defmodule Companion.CompanionWebTest do
  use Companion.DataCase

  alias Companion.CompanionWeb

  describe "applications" do
    alias Companion.CompanionWeb.Application

    @valid_attrs %{name: "some name", token: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{name: "some updated name", token: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{name: nil, token: nil}

    defp assume_ok({:ok, value}), do: value

    def application_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(@valid_attrs)
      |> CompanionWeb.create_application()
      |> assume_ok()
    end

    test "list_applications/0 returns all applications" do
      application = application_fixture()
      assert CompanionWeb.list_applications() == [application]
    end

    test "get_application!/1 returns the application with given id" do
      application = application_fixture()
      assert CompanionWeb.get_application!(application.id) == application
    end

    test "create_application/1 with valid data creates a application" do
      assert {:ok, %Application{} = application} = CompanionWeb.create_application(@valid_attrs)
      assert application.name == "some name"
    end

    test "create_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanionWeb.create_application(@invalid_attrs)
    end

    test "update_application/2 with valid data updates the application" do
      application = application_fixture()
      assert {:ok, application} = CompanionWeb.update_application(application, @update_attrs)
      assert %Application{} = application
      assert application.name == "some updated name"
    end

    test "update_application/2 with invalid data returns error changeset" do
      application = application_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CompanionWeb.update_application(application, @invalid_attrs)

      assert application == CompanionWeb.get_application!(application.id)
    end

    test "delete_application/1 deletes the application" do
      application = application_fixture()
      assert {:ok, %Application{}} = CompanionWeb.delete_application(application)
      assert_raise Ecto.NoResultsError, fn -> CompanionWeb.get_application!(application.id) end
    end

    test "change_application/1 returns a application changeset" do
      application = application_fixture()
      assert %Ecto.Changeset{} = CompanionWeb.change_application(application)
    end
  end

  describe "optouts" do
    alias Companion.CompanionWeb.OptOut

    @valid_attrs %{contact_id: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{contact_id: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{contact_id: nil}

    def opt_out_fixture(attrs \\ %{}) do
      {:ok, opt_out} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CompanionWeb.create_opt_out()

      opt_out
    end

    test "list_optouts/0 returns all optouts" do
      opt_out = opt_out_fixture()
      [result] = CompanionWeb.list_optouts()
      assert result.id == opt_out.id
    end

    test "get_opt_out!/1 returns the opt_out with given id" do
      opt_out = opt_out_fixture()
      assert CompanionWeb.get_opt_out!(opt_out.id).id == opt_out.id
    end

    test "create_opt_out/1 with valid data creates a opt_out" do
      assert {:ok, %OptOut{} = opt_out} = CompanionWeb.create_opt_out(@valid_attrs)
      assert opt_out.contact_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_opt_out/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanionWeb.create_opt_out(@invalid_attrs)
    end

    test "update_opt_out/2 with valid data updates the opt_out" do
      opt_out = opt_out_fixture()
      assert {:ok, opt_out} = CompanionWeb.update_opt_out(opt_out, @update_attrs)
      assert %OptOut{} = opt_out
      assert opt_out.contact_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_opt_out/2 with invalid data returns error changeset" do
      opt_out = opt_out_fixture()
      assert {:error, %Ecto.Changeset{}} = CompanionWeb.update_opt_out(opt_out, @invalid_attrs)
      assert opt_out.id == CompanionWeb.get_opt_out!(opt_out.id).id
    end

    test "delete_opt_out/1 deletes the opt_out" do
      opt_out = opt_out_fixture()
      assert {:ok, %OptOut{}} = CompanionWeb.delete_opt_out(opt_out)
      assert_raise Ecto.NoResultsError, fn -> CompanionWeb.get_opt_out!(opt_out.id) end
    end

    test "change_opt_out/1 returns a opt_out changeset" do
      opt_out = opt_out_fixture()
      assert %Ecto.Changeset{} = CompanionWeb.change_opt_out(opt_out)
    end
  end

  describe "templatemessages" do
    alias Companion.CompanionWeb.TemplateMessage

    @valid_attrs %{
      template: "some template",
      external_id: "some external_id",
      to: "some to",
      variables: ["some", "variables"]
    }
    @update_attrs %{
      template: "some updated template",
      external_id: "some updated external_id",
      to: "some updated to",
      variables: ["some", "updated", "variables"]
    }
    @invalid_attrs %{template: nil, external_id: nil, to: nil}

    def template_message_fixture(attrs \\ %{}) do
      {:ok, template_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CompanionWeb.create_template_message()

      template_message
    end

    test "list_templatemessages/0 returns all templatemessages" do
      template_message = template_message_fixture()
      [result] = CompanionWeb.list_templatemessages()
      result = %{result | honeydew_send_template_message_lock: nil}

      assert result == template_message
    end

    test "get_template_message!/1 returns the template_message with given id" do
      template_message = template_message_fixture()
      result = CompanionWeb.get_template_message!(template_message.id)
      result = %{result | honeydew_send_template_message_lock: nil}
      assert result == template_message
    end

    test "create_template_message/1 with valid data creates a template_message" do
      assert {:ok, %TemplateMessage{} = template_message} =
               CompanionWeb.create_template_message(@valid_attrs)

      assert template_message.template == "some template"
      assert template_message.external_id == "some external_id"
      assert template_message.to == "some to"
      assert template_message.variables == ["some", "variables"]
    end

    test "create_template_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanionWeb.create_template_message(@invalid_attrs)
    end

    test "update_template_message/2 with valid data updates the template_message" do
      template_message = template_message_fixture()

      assert {:ok, template_message} =
               CompanionWeb.update_template_message(template_message, @update_attrs)

      assert %TemplateMessage{} = template_message
      assert template_message.template == "some updated template"
      assert template_message.external_id == "some updated external_id"
      assert template_message.to == "some updated to"
      assert template_message.variables == ["some", "updated", "variables"]
    end

    test "update_template_message/2 with invalid data returns error changeset" do
      template_message = template_message_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CompanionWeb.update_template_message(template_message, @invalid_attrs)

      result = CompanionWeb.get_template_message!(template_message.id)
      result = %{result | honeydew_send_template_message_lock: nil}
      assert result == template_message
    end

    test "delete_template_message/1 deletes the template_message" do
      template_message = template_message_fixture()
      assert {:ok, %TemplateMessage{}} = CompanionWeb.delete_template_message(template_message)

      assert_raise Ecto.NoResultsError, fn ->
        CompanionWeb.get_template_message!(template_message.id)
      end
    end

    test "change_template_message/1 returns a template_message changeset" do
      template_message = template_message_fixture()
      assert %Ecto.Changeset{} = CompanionWeb.change_template_message(template_message)
    end
  end

  describe "registrations" do
    alias Companion.CompanionWeb.Registration

    @valid_attrs %{
      channel: "some channel",
      facility_code: "some facility_code",
      msisdn: "some msisdn",
      persal: "some persal",
      registered_by: "some registered_by",
      sanc: "some sanc",
      timestamp: "2018-01-01T01:01:01.000000"
    }
    @update_attrs %{
      channel: "some updated channel",
      facility_code: "some updated facility_code",
      msisdn: "some updated msisdn",
      persal: "some updated persal",
      registered_by: "some updated registered_by",
      sanc: "some updated sanc",
      timestamp: "2018-01-01T01:01:01.000000"
    }
    @invalid_attrs %{
      channel: nil,
      facility_code: nil,
      msisdn: nil,
      persal: nil,
      registered_by: nil,
      sanc: nil
    }

    def registration_fixture(attrs \\ %{}) do
      {:ok, registration} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CompanionWeb.create_registration()

      registration
    end

    test "list_registrations/0 returns all registrations" do
      registration = registration_fixture()
      [result] = CompanionWeb.list_registrations()
      result = %{result | honeydew_process_registration_lock: nil}
      assert result == registration
    end

    test "get_registration!/1 returns the registration with given id" do
      registration = registration_fixture()
      result = CompanionWeb.get_registration!(registration.id)
      result = %{result | honeydew_process_registration_lock: nil}
      assert result == registration
    end

    test "create_registration/1 with valid data creates a registration" do
      assert {:ok, %Registration{} = registration} =
               CompanionWeb.create_registration(@valid_attrs)

      assert registration.channel == "some channel"
      assert registration.facility_code == "some facility_code"
      assert registration.msisdn == "some msisdn"
      assert registration.persal == "some persal"
      assert registration.registered_by == "some registered_by"
      assert registration.sanc == "some sanc"
    end

    test "create_registration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CompanionWeb.create_registration(@invalid_attrs)
    end

    test "update_registration/2 with valid data updates the registration" do
      registration = registration_fixture()
      assert {:ok, registration} = CompanionWeb.update_registration(registration, @update_attrs)
      assert %Registration{} = registration
      assert registration.channel == "some updated channel"
      assert registration.facility_code == "some updated facility_code"
      assert registration.msisdn == "some updated msisdn"
      assert registration.persal == "some updated persal"
      assert registration.registered_by == "some updated registered_by"
      assert registration.sanc == "some updated sanc"
    end

    test "update_registration/2 with invalid data returns error changeset" do
      registration = registration_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CompanionWeb.update_registration(registration, @invalid_attrs)

      result = CompanionWeb.get_registration!(registration.id)
      result = %{result | honeydew_process_registration_lock: nil}
      assert registration == result
    end

    test "delete_registration/1 deletes the registration" do
      registration = registration_fixture()
      assert {:ok, %Registration{}} = CompanionWeb.delete_registration(registration)
      assert_raise Ecto.NoResultsError, fn -> CompanionWeb.get_registration!(registration.id) end
    end

    test "change_registration/1 returns a registration changeset" do
      registration = registration_fixture()
      assert %Ecto.Changeset{} = CompanionWeb.change_registration(registration)
    end
  end
end
