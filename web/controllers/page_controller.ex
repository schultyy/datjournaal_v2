defmodule Datjournaal.PageController do
  use Datjournaal.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
