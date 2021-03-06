defmodule Doge.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Doge.Repo
  alias Doge.Accounts.User

  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Repo.get(User, String.to_integer(id)) |> Repo.preload(:roles)}
  def from_token(_), do: {:error, "Unknown resource type"}
end