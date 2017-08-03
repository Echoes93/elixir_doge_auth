defmodule DogeWeb.SessionController do
  use DogeWeb, :controller
  
  alias Doge.Accounts
  alias Doge.Accounts.User

  action_fallback DogeWeb.FallbackController


  def signup(conn, params) do
    with {:ok, %User{} = user} <- Accounts.register_user(params) do
      authorize(conn, user)
    end
  end

  def signin(conn, params) do
    with {:ok, %User{} = user} <- Accounts.find_and_confirm_password(params) do
      authorize(conn, user)
    end
  end

  def signout(conn, _) do
    conn
    |> Guardian.Plug.current_token
    |> Guardian.revoke!

    conn
    |> put_status(:ok)
    |> render("signout.json")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(DogeWeb.SessionView, "forbidden.json", error: "Not Authenticated")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(DogeWeb.SessionView, "forbidden.json", error: "Not Authorized")
  end

  defp authorize(conn, user) do
    perms = %{roles: Doge.Accounts.Role.roles_to_atoms(user.roles)}

    new_conn = Guardian.Plug.api_sign_in(conn, user, :token, perms: perms)
    jwt = Guardian.Plug.current_token(new_conn)
    claims = elem(Guardian.Plug.claims(new_conn), 1)
    exp = Map.get(claims, "exp")
    
    new_conn
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> render("signin.json", user: user, jwt: jwt, exp: exp)
  end

end