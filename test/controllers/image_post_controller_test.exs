defmodule Datjournaal.ImagePostControllerTest do
  use Datjournaal.ConnCase
  use ExVCR.Mock
  import Datjournaal.Factory

  alias Datjournaal.ImagePost
  @upload %Plug.Upload{content_type: "image/jpg", path: "test/fixtures/placeholder.jpg", filename: "placeholder.png"}
  @valid_attrs %{description: "some content", image: @upload}
  @invalid_attrs %{}

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = get conn, image_post_path(conn, :new)
    assert html_response(conn, 200) =~ "Create a new Image post"
  end

  test "does not render form for new resources when user is not logged in", %{conn: conn} do
    conn = get conn, image_post_path(conn, :new)
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "creates resource and redirects when data is valid and user is logged in", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, image_post_path(conn, :create), image_post: @valid_attrs
    assert redirected_to(conn) == index_path(conn, :index)
    assert Repo.one(from x in ImagePost, order_by: [desc: x.id], limit: 1)
  end

  test "creates resource and redirects when data is valid and user is not logged in", %{conn: conn} do
    conn = post conn, image_post_path(conn, :create), image_post: @valid_attrs
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "creates resource and calculates a slug", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    post conn, image_post_path(conn, :create), image_post: @valid_attrs
    post = Repo.one(from x in ImagePost, order_by: [desc: x.id], limit: 1)
    assert post.slug != nil
  end

  test "creates resource and associates it with current user", %{conn: conn} do
    current_user = insert(:user)
    conn = conn
           |> guardian_login(current_user)
    post conn, image_post_path(conn, :create), image_post: @valid_attrs
    post = Repo.one(from x in ImagePost, order_by: [desc: x.id], limit: 1) |> Repo.preload(:user)
    assert post.user.id == current_user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
           |> guardian_login(insert(:user))
    conn = post conn, image_post_path(conn, :create), image_post: @invalid_attrs
    assert html_response(conn, 200) =~ "Create a new Image post"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = insert(:user)
    post = insert(:post, user: user)
    conn = conn
           |> guardian_login(user)
    conn = delete conn, image_post_path(conn, :delete, post.slug)
    assert redirected_to(conn) == index_path(conn, :index)
    refute Repo.get(ImagePost, post.id)
  end

  test "does not delete chosen resource when user is not authenticated", %{conn: conn} do
    user = insert(:user)
    post = insert(:post, user: user)
    conn = delete conn, image_post_path(conn, :delete, post.slug)
    assert redirected_to(conn) == session_path(conn, :new)
    assert Repo.get(ImagePost, post.id)
  end

  test "does not delete chosen resource when it doesn't belong to current user", %{conn: conn} do
    alice = insert(:user)
    bob = insert(:user)
    conn = conn
           |> guardian_login(alice)
    post = insert(:post, user: bob)
    conn = delete conn, image_post_path(conn, :delete, post.slug)
    assert redirected_to(conn) == index_path(conn, :show_image, post.slug)
    assert Repo.get(ImagePost, post.id)
  end

  test "create post with Google Places Id queries for lat/long and displayname", %{conn: conn} do
    use_cassette "elbphilharmonie_places_id_query" do
      current_user = insert(:user)
      conn = conn
            |> guardian_login(current_user)
      places_id = "ChIJT8RwZwaPsUcRhkKYaCqr5LI" #Elbphilharmonie Hamburg, Platz der Deutschen Einheit, Hamburg, Germany
      form_data = %{description: "some content", image: @upload, places_id: places_id}
      response = post conn, image_post_path(conn, :create), image_post: form_data
      post = Repo.one(from x in ImagePost, order_by: [desc: x.id], limit: 1)
      assert response.status == 302
      assert post.lat == 53.54133059999999
      assert post.lng == 9.9841274
      assert post.short_location_name == "Elbphilharmonie Hamburg"
      assert post.long_location_name == "Platz der Deutschen Einheit 1, 20457 Hamburg, Germany"
    end
  end
end
