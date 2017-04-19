defmodule Datjournaal.TwitterAuthController do
  use Datjournaal.Web, :controller

  alias Datjournaal.Router

  def request(conn, _params) do
    token = ExTwitter.request_token(
      Router.Helpers.twitter_auth_url(conn, :callback)
    )
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)
    redirect conn, external: authenticate_url
  end

  def callback(conn, %{"oauth_token" => oauth_token, "oauth_verifier" => oauth_verifier}) do
    {:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)
    ExTwitter.configure(
      :process,
      Enum.concat(
        ExTwitter.Config.get_tuples,
        [ access_token: access_token.oauth_token,
          access_token_secret: access_token.oauth_token_secret ]
      )
    )

    user_info = ExTwitter.verify_credentials()
    create_key_or_update(conn, %{
      name: user_info.name,
      screen_name: user_info.screen_name,
      access_token: access_token.oauth_token,
      access_token_secret: access_token.oauth_token_secret
    })

    redirect conn, to: Router.Helpers.post_path(conn, :index)
  end

  def callback(conn, %{"denied" => _}) do
    conn
    |> put_flash(:error, "You did not give us access to your account")
    |> redirect(to: Router.Helpers.post_path(conn, :index))
  end

  def logout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Router.Helpers.post_path(conn, :index))
  end

  defp create_key_or_update(conn, params) do
    current_user = conn.assigns.current_user
    user_with_key = Repo.one(from u in Datjournaal.User, where: u.id == ^current_user.id) |> Repo.preload(:twitterkey)
    changeset = case user_with_key.twitterkey do
      nil ->
        conn.assigns.current_user
        |> build_assoc(:twitterkey)
        |> Datjournaal.TwitterKey.changeset(params)
      _ ->
        Datjournaal.TwitterKey.changeset(user_with_key.twitterkey, params)
    end
    { :ok, _t } = Repo.insert_or_update(changeset)
  end
end
