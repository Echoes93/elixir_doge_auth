defmodule Doge.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Doge.Accounts.User


  schema "users" do
    field :email, :string
    field :username, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    many_to_many :roles, Doge.Accounts.Role, join_through: "users_roles"

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :hashed_password])
    |> validate_required([:email, :hashed_password])
    |> unique_constraint(:email)
  end

  def signin_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end

  def signup_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    # |> validate_length(:password, min: 6, max: 100)
    |> hash_password()
  end

  def error_changeset(key, value) do
    %User{}
    |> cast(%{}, [])
    |> add_error(key, value)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

end
