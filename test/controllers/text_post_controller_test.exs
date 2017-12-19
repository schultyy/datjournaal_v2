defmodule Datjournaal.TextPostControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.TextPost
  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = get conn, text_post_path(conn, :new)
    assert html_response(conn, 200) =~ "New text post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, text_post_path(conn, :create), text_post: @valid_attrs
    assert redirected_to(conn) == index_path(conn, :index)
    assert Repo.get_by(TextPost, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, text_post_path(conn, :create), text_post: @invalid_attrs
    assert html_response(conn, 200) =~ "New text post"
  end

  test "shows chosen resource", %{conn: conn} do
    text_post = Repo.insert! %TextPost{}
    conn = get conn, text_post_path(conn, :show, text_post)
    assert html_response(conn, 200) =~ "Show text post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, text_post_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    text_post = Repo.insert! %TextPost{}
    conn = get conn, text_post_path(conn, :edit, text_post)
    assert html_response(conn, 200) =~ "Edit text post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    text_post = Repo.insert! %TextPost{}
    conn = put conn, text_post_path(conn, :update, text_post), text_post: @valid_attrs
    assert redirected_to(conn) == text_post_path(conn, :show, text_post)
    assert Repo.get_by(TextPost, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    text_post = Repo.insert! %TextPost{}
    conn = put conn, text_post_path(conn, :update, text_post), text_post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit text post"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    text_post = Repo.insert! %TextPost{}
    conn = delete conn, text_post_path(conn, :delete, text_post)
    assert redirected_to(conn) == index_path(conn, :index)
    refute Repo.get(TextPost, text_post.id)
  end
end
