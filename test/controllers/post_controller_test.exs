defmodule Datjournaal.PostControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.Post
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 200) =~ "New post"
  end

  test "does not render form for new resources when user is not logged in", %{conn: conn} do
    conn = get conn, post_path(conn, :new)
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "creates resource and redirects when data is valid and user is logged in", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "creates resource and redirects when data is valid and user is not logged in", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "creates resource and calculates a slug", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    post conn, post_path(conn, :create), post: @valid_attrs
    post = Repo.get_by(Post, @valid_attrs)
    assert post.slug != nil
  end

  test "creates resource and associates it with current user", %{conn: conn} do
    current_user = insert(:user)
    conn = conn
           |> guardian_login(current_user)
    post conn, post_path(conn, :create), post: @valid_attrs
    post = Repo.get_by(Post, @valid_attrs) |> Repo.preload(:user)
    assert post.user.id == current_user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn} do
    post = Repo.insert! Post.changeset(%Post{}, @valid_attrs)
    conn = get conn, post_path(conn, :show, post.slug)
    assert html_response(conn, 200) =~ "Show post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    post = Repo.insert! Post.changeset(%Post{}, @valid_attrs)
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end

  test "does not delete chosen resource when user is not authenticated", %{conn: conn} do
    post = Repo.insert! Post.changeset(%Post{}, @valid_attrs)
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == session_path(conn, :new)
    assert Repo.get(Post, post.id)
  end
end
