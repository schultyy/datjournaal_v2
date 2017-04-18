defmodule Datjournaal.UserSettingsController do
  use Datjournaal.Web, :controller

  def index(conn, _params) do
    current_user = Repo.preload(conn.assigns.current_user, :twitterkey)
    render(conn, "index.html", user: current_user)
  end

  def destroy(_conn, _params) do
  end
end