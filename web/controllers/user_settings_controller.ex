defmodule Datjournaal.UserSettingsController do
  use Datjournaal.Web, :controller

  alias Datjournaal.{Repo, User, TwitterKey}

  def index(conn, _params) do
    current_user = Repo.preload(conn.assigns.current_user, :twitterkey)
    render(conn, "index.html", user: current_user)
  end

  def delete(conn, %{"id" => id}) do
    key = Repo.get!(TwitterKey, id)
    Repo.delete!(key)
    conn |> redirect(to: user_settings_path(conn, :index))
  end
end