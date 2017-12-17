defmodule Datjournaal.UserStatsControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.ImagePost
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}

  test "renders user stats page", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> ImagePost.changeset(@valid_attrs)
    post = Repo.insert! changeset

    stats = Datjournaal.Stat.changeset(%Datjournaal.Stat{}, %{
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
