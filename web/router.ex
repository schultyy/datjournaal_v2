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
  end

  scope "/", Datjournaal do
    pipe_through [:browser, :with_session]

    get "/", PostController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/:slug", PostController, :show

    scope "/" do
      pipe_through [:login_required]
      resources "/posts", PostController, only: [:create, :delete, :new]
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", Datjournaal do
  #   pipe_through :api
  # end
end
