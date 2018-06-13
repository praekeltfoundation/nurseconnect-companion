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
end
