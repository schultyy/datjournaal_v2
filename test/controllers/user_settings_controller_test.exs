defmodule Datjournaal.UserSettingsControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  setup do
    user = insert(:user)
    user
    |> build_assoc(:twitterkey)
    |> Datjournaal.TwitterKey.changeset(%{
        access_token: "a token",
        access_token_secret: "A secret",
        screen_name: "Swift on Development",
        name: "SwiftOnDev"
      })
    |> Repo.insert
    {:ok, %{user: Repo.preload(user, :twitterkey)}}
  end

  test "renders user's twitter account details", %{conn: conn, user: user} do
    conn = conn |> guardian_login(user)
    response = get conn, user_settings_path(conn, :index)
    assert html_response(response, 200) =~ user.twitterkey.name
    assert html_response(response, 200) =~ user.twitterkey.screen_name
  end

  test "does not render page if user's not authenticated", %{conn: conn, user: _user} do
    response = get conn, user_settings_path(conn, :index)
    assert response.status == 302
  end

  test "deletes a user's twitter key", %{conn: conn, user: user} do
    conn = conn |> guardian_login(user)
    user_with_key = Repo.preload(user, :twitterkey)
    response = delete conn, user_settings_path(conn, :delete, user_with_key.twitterkey.id)
    assert response.status == 302
    user = Repo.get_by(Datjournaal.User, id: user.id) |> Repo.preload(:twitterkey)
    assert user.twitterkey == nil
  end
end