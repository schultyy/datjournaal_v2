defmodule Datjournaal.TrackingController do
  use Datjournaal.Web, :controller

  def log_visit(conn, _params) do
    render(conn, "tracking.json", %{})
  end
end
