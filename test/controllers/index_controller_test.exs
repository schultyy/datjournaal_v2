defmodule Datjournaal.IndexControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.ImagePost
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}

  test "lists all entries on index", %{conn: conn} do
    user = insert(:user)
    _text_post = insert(:text_post, %{ user: user })
    _post = insert(:post, %{ user: user })
    conn = get conn, index_path(conn, :index)
    assert conn.status == 200
  end

  test "shows chosen resource", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> ImagePost.changeset(@valid_attrs)
    post = Repo.insert! changeset
    conn = get conn, index_path(conn, :show, post.slug)
    assert conn.status == 200
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, index_path(conn, :show, -1)
    end
  end

end
