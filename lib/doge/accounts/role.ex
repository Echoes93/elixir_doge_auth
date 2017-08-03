defmodule Doge.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Doge.Accounts.Role


  schema "roles" do
    field :role, :string
    many_to_many :users, Doge.Accounts.User, join_through: "users_roles"
  end

  @doc false
  def changeset(%Role{} = role, attrs) do
    role
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> unique_constraint(:role)
  end

  def roles_to_atoms(roles_list) do
    Enum.map(roles_list, &match_role/1)
  end

  # TODO: MOVE ROLE DEFENITION TO CONFIG FILE
  defp match_role(role) do
    case role.role do
      "Admin" -> :admin
      "User"  -> :user
      _       -> :unknown_role
    end
  end
end
