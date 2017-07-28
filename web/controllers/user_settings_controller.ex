defmodule Datjournaal.UserSettingsController do
  use Datjournaal.Web, :controller

  alias Datjournaal.{Repo, User, TwitterKey}

  def index(conn, _params) do
    current_user = Repo.preload(conn.assigns.current_user, :twitterkey)
    changeset = User.change_password_changeset(%{})
    render(conn, "index.html", user: current_user, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    key = Repo.get!(TwitterKey, id)
    Repo.delete!(key)
    conn |> redirect(to: user_settings_path(conn, :index))
  end

  def change_password(conn, params) do
    current_user = conn.assigns.current_user
    changeset = current_user |> User.change_password_changeset(params)

    case Repo.update(changeset) do
      {:ok, _user}         -> conn |> redirect(to: user_settings_path(conn, :index))
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> render("index.html", %{ changeset: changeset, user: Repo.preload(current_user, :twitterkey) })
    end
  end
end
