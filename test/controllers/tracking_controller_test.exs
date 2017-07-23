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
end
