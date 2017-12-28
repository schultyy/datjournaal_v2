defmodule Datjournaal.IndexControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.ImagePost

  setup do
    user = insert(:user)

    text_post = insert(:text_post, %{ user: user })
    image_post = insert(:post, %{ user: user })
    {:ok, %{text_post: text_post, image_post: image_post}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, index_path(conn, :index)
    assert conn.status == 200
  end

  # Note that this tests legacy behavior
  test "/:slug returns image post", %{conn: conn, text_post: text_post, image_post: image_post} do
    conn = get conn, index_path(conn, :show_legacy, image_post.slug)
    assert conn.status == 200
  end

  test "/:slug does not return text post", %{conn: conn, text_post: text_post, image_post: image_post} do
    assert_error_sent 404, fn ->
      get conn, index_path(conn, :show_legacy, text_post.slug)
    end
  end

  test "/images/:slug returns image post", %{conn: conn, text_post: text_post, image_post: image_post} do
    conn = get conn, index_path(conn, :show_image, image_post.slug)
    assert conn.status == 200
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, index_path(conn, :show_legacy, -1)
    end
  end

end
