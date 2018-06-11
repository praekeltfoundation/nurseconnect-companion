defmodule CompanionWeb.Router do
  use CompanionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :logged_in do
    plug CompanionWeb.Plugs.RequireLoggedIn, "/auth/login"
  end

  scope "/", CompanionWeb do
    # Use the default browser stack
    pipe_through [:browser, :logged_in]

    get "/", PageController, :index
  end

  scope "/auth", CompanionWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
