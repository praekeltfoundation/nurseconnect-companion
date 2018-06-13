defmodule Companion.CompanionWeb do
  @moduledoc """
  The CompanionWeb context.
  """

  import Ecto.Query, warn: false
  alias Companion.Repo

  alias Companion.CompanionWeb.Application

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(Application)
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Gets an application by the token.

  ## Examples

      iex> get_application_by_token("example-token")
      %Application{}

      iex> get_application_by_token("bad-token")
      nil

  """
  def get_application_by_token(token) do
    case Ecto.UUID.cast(token) do
      {:ok, token} -> Repo.get_by(Application, token: token)
      :error -> nil
    end
  end

  @doc """
  Creates an application.

  ## Examples

      iex> create_application(%{name: "example"})
      {:ok, %Application{}}

      iex> create_application(%{})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an application.

  ## Examples

      iex> update_application(application, %{name: "new name"})
      {:ok, %Application{}}

      iex> update_application(application, %{})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(%Application{})
      %Ecto.Changeset{source: %Application{}}

  """
  def change_application(%Application{} = application) do
    Application.changeset(application, %{})
  end
end
