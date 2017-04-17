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
    user_obj = %{ name: user_info.name, screen_name: user_info.screen_name }

    conn = conn
      |> put_session(:current_user, user_obj)
      |> put_session(:access_token, access_token.oauth_token)
      |> put_session(:access_token_secret, access_token.oauth_token_secret)

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

end
