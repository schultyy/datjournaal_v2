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

  test "POST /api/v1/users/reset_password with new password redirects to user settings page", %{conn: conn, user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = "test12345!"
    response = post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    assert response.status == 302
  end

  test "POST /api/v1/users/reset_password with new password sets new password in database", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = "test12345!"
    post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    updated_user = Datjournaal.Repo.get_by(Datjournaal.User, id: user.id)
    assert(Comeonin.Bcrypt.checkpw(new_password, updated_user.password_hash))
  end

  test "POST /api/v1/users/reset_password with new password and invalid old password does not set new password in database", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = "test12345!"
    post conn, "/settings/change_password", %{ old_password: "fsdfsd", password: new_password }
    updated_user = Datjournaal.Repo.get_by(Datjournaal.User, id: user.id)
    assert(Comeonin.Bcrypt.checkpw(old_password, updated_user.password_hash))
  end

  test "POST /api/v1/users/reset_password with new password and invalid old password rerenders user settings page", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    new_password = "test12345!"
    response = post conn, "/settings/change_password", %{ old_password: "fsdfsd", password: new_password }
    assert(response.status == 200)
  end

  test "POST /api/v1/users/reset_password with too short new password rerenders user settings page", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = "test"
    response = post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    assert(response.status == 200)
  end

  test "POST /api/v1/users/reset_password with too short new password does not set new password in database", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = "test"
    post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    updated_user = Datjournaal.Repo.get_by(Datjournaal.User, id: user.id)
    assert(Comeonin.Bcrypt.checkpw(old_password, updated_user.password_hash))
  end

  test "POST /api/v1/users/reset_password with empty new password rerenders user settings page", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = ""
    response = post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    assert(response.status == 200)
  end

  test "POST /api/v1/users/reset_password with empty new password does not set new password in database", %{user: user, conn: conn} do
    conn = conn |> guardian_login(user)
    old_password = "tester1234"
    new_password = ""
    post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    updated_user = Datjournaal.Repo.get_by(Datjournaal.User, id: user.id)
    assert(Comeonin.Bcrypt.checkpw(old_password, updated_user.password_hash))
  end

  test "POST /api/v1/users/reset_password with new password but without session returns 302", %{user: user, conn: conn} do
    old_password = "tester1234"
    new_password = "test12345!"
    response = post conn, "/settings/change_password", %{ old_password: old_password, password: new_password }
    assert response.status == 302
  end
end
