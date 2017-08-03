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
end
