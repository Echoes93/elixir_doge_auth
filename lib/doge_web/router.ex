defmodule DogeWeb.Router do
  use DogeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :auth_required do
    plug Guardian.Plug.EnsureAuthenticated, handler: DogeWeb.SessionController
  end

  pipeline :admin_routes do
    plug Guardian.Plug.EnsurePermissions, on_failure: { DogeWeb.SessionController, :unauthorized }, roles: [:admin]
  end

  scope "/api", DogeWeb do
    pipe_through :api

    post "/signup", SessionController, :signup
    post "/signin", SessionController, :signin
    get "/signout", SessionController, :signout

    scope "/users" do
      pipe_through [:auth_required, :admin_routes]

      resources "/", UserController
    end
  end
end
