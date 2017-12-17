defmodule Datjournaal.IndexControllerTest do
  use Datjournaal.ConnCase
  use ExVCR.Mock

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, index_path(conn, :index)
    assert conn.status == 200
  end
end
