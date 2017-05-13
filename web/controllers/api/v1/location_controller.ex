defmodule Datjournaal.LocationController do
  use Datjournaal.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, [handler: Datjournaal.SessionController]

  def get_location_for_name(conn, %{"location_name" => location_name} = _params) do
    results = Datjournaal.GmapsApiClient.place_autocomplete(location_name)
    render(conn, "location.json", results)
  end
end