defmodule Datjournaal.Router do
  use Datjournaal.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Datjournaal.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: Datjournaal.GuardianErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
  end

  scope "/", Datjournaal do
    pipe_through [:browser, :with_session]

    get "/", PostController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    scope "/" do
      pipe_through [:login_required]
      resources "/posts", PostController, only: [:create, :delete, :new]
      resources "/settings", UserSettingsController, only: [:index, :delete]
      get "/auth/request", TwitterAuthController, :request
      get "/auth/callback", TwitterAuthController, :callback
      get "/auth/logout", TwitterAuthController, :logout
    end

    get "/:slug", PostController, :show #This has to be the last route in the file because it acts as a catch-all
  end
  # Other scopes may use custom stacks.
  scope "/api", Datjournaal do
    pipe_through [:api, :with_session, :login_required]
    scope "v1" do
      get "/location", LocationController, :get_location_for_name
    end
  end
end
