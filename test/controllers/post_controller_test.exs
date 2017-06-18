defmodule Datjournaal.PostControllerTest do
  use Datjournaal.ConnCase
  use ExVCR.Mock
  import Datjournaal.Factory

  alias Datjournaal.Post
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}
  @invalid_attrs %{}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert conn.status == 200
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 200) =~ "Create a new post"
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
    assert html_response(conn, 200) =~ "Create a new post"
  end

  test "shows chosen resource", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> Post.changeset(@valid_attrs)
    post = Repo.insert! changeset
    conn = get conn, post_path(conn, :show, post.slug)
    assert conn.status == 200
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> Post.changeset(@valid_attrs)
    post = Repo.insert! changeset
    conn = conn
           |> guardian_login(user)
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :index)
    refute Repo.get(Post, post.id)
  end

  test "does not delete chosen resource when user is not authenticated", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> Post.changeset(@valid_attrs)
    post = Repo.insert! changeset
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == session_path(conn, :new)
    assert Repo.get(Post, post.id)
  end

  test "does not delete chosen resource when it doesn't belong to current user", %{conn: conn} do
    alice = insert(:user)
    bob = insert(:user)
    conn = conn
           |> guardian_login(alice)
    changeset = bob
                |> build_assoc(:posts)
                |> Post.changeset(@valid_attrs)
    post = Repo.insert!(changeset)
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :show, post.slug)
    assert Repo.get(Post, post.id)
  end

  test "create post with Google Places Id queries for lat/long and displayname", %{conn: conn} do
    use_cassette "elbphilharmonie_places_id_query" do
      current_user = insert(:user)
      conn = conn
            |> guardian_login(current_user)
      places_id = "ChIJT8RwZwaPsUcRhkKYaCqr5LI" #Elbphilharmonie Hamburg, Platz der Deutschen Einheit, Hamburg, Germany
      form_data = %{description: "some content", image: @upload, places_id: places_id}
      response = post conn, post_path(conn, :create), post: form_data
      post = Repo.one(from x in Datjournaal.Post, order_by: [desc: x.id], limit: 1)
      assert response.status == 302
      assert post.lat == 53.54133059999999
      assert post.lng == 9.9841274
      assert post.short_location_name == "Elbphilharmonie Hamburg"
      assert post.long_location_name == "Platz der Deutschen Einheit 1, 20457 Hamburg, Germany"
    end
  end

  test "logs visit to post's detail page", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> Post.changeset(@valid_attrs)
    post = Repo.insert! changeset
    get conn, post_path(conn, :show, post.slug)
    stat = Repo.one(from x in Datjournaal.Stat, order_by: [desc: x.id], limit: 1)
    assert stat.post_id == post.id
    assert stat.authenticated == false
  end

  test "logs visit to post's detail page and stores if the user was authenticated", %{conn: conn} do
    user = insert(:user)
    changeset = user
            |> build_assoc(:posts)
            |> Post.changeset(@valid_attrs)
    post = Repo.insert! changeset
    get conn |> guardian_login(user), post_path(conn, :show, post.slug)
    stat = Repo.one(from x in Datjournaal.Stat, order_by: [desc: x.id], limit: 1)
    assert stat.authenticated == true
  end
end
