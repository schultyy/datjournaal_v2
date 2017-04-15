defmodule Datjournaal.PostControllerTest do
  use Datjournaal.ConnCase

  alias Datjournaal.Post
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "creates resource and calculates a slug", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    post = Repo.get_by(Post, @valid_attrs)
    assert post.slug != nil
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn} do
    post = Repo.insert! Post.changeset(%Post{}, @valid_attrs)
    conn = get conn, post_path(conn, :show, post)
    assert html_response(conn, 200) =~ "Show post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    post = Repo.insert! Post.changeset(%Post{}, @valid_attrs)
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end
end
