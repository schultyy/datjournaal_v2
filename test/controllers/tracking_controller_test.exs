defmodule Datjournaal.TrackingControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  setup do
    image_post = insert(:post)
    text_post = insert(:text_post)
    { :ok, image_post: image_post, text_post: text_post }
  end

  test "POST /api/v1/visit/image/:id returns 200 status code", %{ conn: conn, image_post: image_post, text_post: _text_post } do
    response = post conn, "/api/v1/visit/image/#{image_post.slug}"
    assert response.status == 200
  end

  test "POST /api/v1/visit/image/:id creates new log entry", %{ conn: conn, image_post: image_post, text_post: _text_post } do
    post conn, "/api/v1/visit/image/#{image_post.slug}"
    stat = Repo.one(from x in Datjournaal.ImageStat, order_by: [desc: x.id], limit: 1)
    assert stat.image_post_id == image_post.id
    assert stat.authenticated == false
  end

  test "POST /api/v1/visit/image/:id as logged in user returns 200", %{ conn: conn, image_post: image_post, text_post: _text_post } do
    current_user = insert(:user)
    conn = conn |> guardian_login(current_user)
    response = post conn, "/api/v1/visit/image/#{image_post.slug}"
    assert response.status == 200
  end

  test "POST /api/v1/visit/image/:id as logged in user logs visit with authenticated == true", %{ conn: conn, image_post: image_post, text_post: _text_post } do
    current_user = insert(:user)
    conn = conn |> guardian_login(current_user)
    post conn, "/api/v1/visit/image/#{image_post.slug}"
    stat = Repo.one(from x in Datjournaal.ImageStat, order_by: [desc: x.id], limit: 1)
    assert stat.image_post_id == image_post.id
    assert stat.authenticated == true
  end

  test "POST /api/v1/visit/text/:id returns 200 status code", %{ conn: conn, image_post: _image_post, text_post: text_post } do
    response = post conn, "/api/v1/visit/text/#{text_post.slug}"
    assert response.status == 200
  end

  test "POST /api/v1/visit/text/:id creates new log entry", %{ conn: conn, image_post: _image_post, text_post: text_post } do
    post conn, "/api/v1/visit/text/#{text_post.slug}"
    stat = Repo.one(from x in Datjournaal.TextStat, order_by: [desc: x.id], limit: 1)
    assert stat.text_post_id == text_post.id
    assert stat.authenticated == false
  end

  test "POST /api/v1/visit/text/:id as logged in user returns 200", %{ conn: conn, image_post: _image_post, text_post: text_post } do
    current_user = insert(:user)
    conn = conn |> guardian_login(current_user)
    response = post conn, "/api/v1/visit/text/#{text_post.slug}"
    assert response.status == 200
  end

  test "POST /api/v1/visit/text/:id as logged in user logs visit with authenticated == true", %{ conn: conn, image_post: _image_post, text_post: text_post } do
    current_user = insert(:user)
    conn = conn |> guardian_login(current_user)
    post conn, "/api/v1/visit/text/#{text_post.slug}"
    stat = Repo.one(from x in Datjournaal.TextStat, order_by: [desc: x.id], limit: 1)
    assert stat.text_post_id == text_post.id
    assert stat.authenticated == true
  end

end
