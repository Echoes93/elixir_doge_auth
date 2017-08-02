defmodule DogeWeb.SessionView do
  use DogeWeb, :view

  def render("signin.json", %{user: user, jwt: jwt, exp: exp}) do
    %{
      data: render_one(user, DogeWeb.UserView, "user.json"),
      meta: %{token: jwt, expires: exp}
    }
  end

  def render("error.json", _) do
    %{error: "Invalid email or password"}
  end

  def render("signout.json", _) do
    %{ok: true}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end