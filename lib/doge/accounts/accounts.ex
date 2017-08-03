defmodule Doge.Accounts do

  import Ecto.Query, warn: false

  alias Doge.Repo
  alias Doge.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register_user(attrs) do
    %User{}
    |> User.signup_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def find_and_confirm_password(params) do
    changeset = User.signin_changeset(%User{}, params)
    
    if changeset.valid? do
      find_user changeset
    else
      {:error, changeset}
    end
  end

  defp find_user(%{ changes: %{"email": email, "password": password} }) do
      case Repo.get_by(User, email: email) |> Repo.preload(:roles) do
        %User{} = user -> check_password user, password
        nil -> { :error, User.error_changeset(:email, "User not found") }
      end
  end

  defp check_password(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.hashed_password) do
      true  -> { :ok, user }
      false -> { :error, User.error_changeset(:password, "Password mismatch") }
    end
  end


  alias Doge.Accounts.Role

  def list_roles do
    Repo.all(Role)
  end

  def get_role!(id), do: Repo.get!(Role, id)


  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end
end
