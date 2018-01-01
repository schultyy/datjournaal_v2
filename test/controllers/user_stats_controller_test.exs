defmodule Datjournaal.UserStatsControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  test "renders user stats page", %{conn: conn} do
    user = insert(:user)
    image_post = insert(:post, user: user)
    text_post = insert(:text_post, user: user)

    image_stats = Datjournaal.ImageStat.changeset(%Datjournaal.ImageStat{}, %{
      unique_identifier: "127.0.0.1",
      authenticated: false,
      image_post_id: post.id
    })
    Repo.insert!(image_stats)

    text_stats = Datjournaal.TextStat.changeset(%Datjournaal.TextStat{}, %{
      unique_identifier: "127.0.0.1",
      authenticated: false,
      text_post_id: text_post.id
    })
    Repo.insert!(text_stats)

    conn = conn
           |> guardian_login(user)
    conn = get conn, user_stats_path(conn, :index)
    assert html_response(conn, 200) =~ "My popular posts"
  end
end
