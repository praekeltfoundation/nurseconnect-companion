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
      assert CompanionWeb.list_optouts() == [opt_out]
    end

    test "get_opt_out!/1 returns the opt_out with given id" do
      opt_out = opt_out_fixture()
      assert CompanionWeb.get_opt_out!(opt_out.id) == opt_out
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
      assert opt_out == CompanionWeb.get_opt_out!(opt_out.id)
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
end
