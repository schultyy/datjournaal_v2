defmodule Datjournaal.TrackingControllerTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  test "POST /api/v1/visit/:id returns 200 status code", %{ conn: conn } do
    post = insert(:post)
    response = post conn, "/api/v1/visit/#{post.slug}"
    assert response.status == 200
  end
end
