defmodule Doge.Repo.Migrations.CreateRoles do
  use Ecto.Migration
  alias Doge.Accounts.Role
  

  def change do
    create table(:roles) do
      add :role, :string
    end

    create table(:users_roles, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)
    end

    create unique_index(:roles, [:role])
  end
end
