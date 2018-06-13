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

  alias Companion.CompanionWeb.OptOut

  @doc """
  Returns the list of optouts.

  ## Examples

      iex> list_optouts()
      [%OptOut{}, ...]

  """
  def list_optouts do
    Repo.all(OptOut)
  end

  @doc """
  Gets a single opt_out.

  Raises `Ecto.NoResultsError` if the Opt out does not exist.

  ## Examples

      iex> get_opt_out!(123)
      %OptOut{}

      iex> get_opt_out!(456)
      ** (Ecto.NoResultsError)

  """
  def get_opt_out!(id), do: Repo.get!(OptOut, id)

  @doc """
  Creates a opt_out.

  ## Examples

      iex> create_opt_out(%{field: value})
      {:ok, %OptOut{}}

      iex> create_opt_out(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_opt_out(attrs \\ %{}) do
    %OptOut{}
    |> OptOut.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a opt_out.

  ## Examples

      iex> update_opt_out(opt_out, %{field: new_value})
      {:ok, %OptOut{}}

      iex> update_opt_out(opt_out, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_opt_out(%OptOut{} = opt_out, attrs) do
    opt_out
    |> OptOut.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a OptOut.

  ## Examples

      iex> delete_opt_out(opt_out)
      {:ok, %OptOut{}}

      iex> delete_opt_out(opt_out)
      {:error, %Ecto.Changeset{}}

  """
  def delete_opt_out(%OptOut{} = opt_out) do
    Repo.delete(opt_out)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking opt_out changes.

  ## Examples

      iex> change_opt_out(opt_out)
      %Ecto.Changeset{source: %OptOut{}}

  """
  def change_opt_out(%OptOut{} = opt_out) do
    OptOut.changeset(opt_out, %{})
  end
end
