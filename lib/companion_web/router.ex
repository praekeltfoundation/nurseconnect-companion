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
    plug CompanionWeb.Plugs.ExtractUserFromSession
    plug CompanionWeb.Plugs.RequireLoggedIn, "/auth/login"
  end

  pipeline :authenticated do
    plug CompanionWeb.Plugs.ExtractApplicationFromHeader
    plug CompanionWeb.Plugs.RequireApplication
  end

  scope "/", CompanionWeb do
    # Use the default browser stack
    pipe_through [:browser, :logged_in]

    get "/", ApplicationController, :index
    resources "/applications", ApplicationController, only: [:create, :delete]
  end

  scope "/auth", CompanionWeb do
    pipe_through :browser

    get "/login", AuthController, :login
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/api/v1", CompanionWeb do
    pipe_through [:api, :authenticated]

    get "/", ApiRootController, :index
  end
end
