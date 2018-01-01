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

    get "/", IndexController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    scope "/" do
      pipe_through [:login_required]
      resources "/posts", ImagePostController, only: [:create, :delete, :new]
      resources "/settings", UserSettingsController, only: [:index, :delete]
      resources "/stats", UserStatsController, only: [:index]
      resources "/text_posts", TextPostController, only: [:new, :edit, :create, :delete, :update]
      get "/auth/request", TwitterAuthController, :request
      get "/auth/callback", TwitterAuthController, :callback
      get "/auth/logout", TwitterAuthController, :logout
    end
    get "/about", StaticPagesController, :about
    get "/texts/:slug", IndexController, :show_text
    get "/images/:slug", IndexController, :show_image
    get "/:slug", IndexController, :show_legacy #This has to be the last route in the file because it acts as a catch-all
  end
  # Other scopes may use custom stacks.
  scope "/api", Datjournaal do
    pipe_through [:api]
    scope "/" do
      pipe_through [:with_session]
      scope "v1" do
        pipe_through [:login_required]
        get "/location", LocationController, :get_location_for_name
      end
      scope "v1" do
        post "/visit/image/:id", TrackingController, :log_image_visit
      end
    end
  end
end
