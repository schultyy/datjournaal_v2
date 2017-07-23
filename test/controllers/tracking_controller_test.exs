defmodule Datjournaal.TrackingControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  setup do
    post = insert(:post)
    { :ok, post: post }
  end

  test "POST /api/v1/visit/:id returns 200 status code", %{ conn: conn, post: post } do
    response = post conn, "/api/v1/visit/#{post.slug}"
    assert response.status == 200
  end

  test "POST /api/v1/visit/:id creates new log entry", %{ conn: conn, post: post } do
    post conn, "/api/v1/visit/#{post.slug}"
    stat = Repo.one(from x in Datjournaal.Stat, order_by: [desc: x.id], limit: 1)
    assert stat.post_id == post.id
  end
end
