defmodule Datjournaal.UserStatsControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  test "renders user stats page", %{conn: conn} do
    user = insert(:user)
    post = insert(:post, user: user)

    stats = Datjournaal.ImageStat.changeset(%Datjournaal.ImageStat{}, %{
      unique_identifier: "127.0.0.1",
      authenticated: false,
      image_post_id: post.id
    })
    Repo.insert!(stats)

    conn = conn
           |> guardian_login(user)
    conn = get conn, user_stats_path(conn, :index)
    assert html_response(conn, 200) =~ "My popular posts"
  end
end
