defmodule Datjournaal.StaticPagesController do
  use Datjournaal.Web, :controller

  def about(conn, _params) do
    render(conn, "about.html", %{})
  end
end
