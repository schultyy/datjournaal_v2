defmodule Datjournaal.LocationControllerTest do
  use Datjournaal.ConnCase
  use ExVCR.Mock
  import Datjournaal.Factory

  setup_all do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes")
    :ok
  end

  test "GET /api/v1/location without token returns 302 redirect", %{conn: conn} do
    location_name = "Elbgold" |> URI.encode
    use_cassette "elbgold_search_location" do
      response = get conn, "/api/v1/location?location_name=#{location_name}"
      assert response.status == 302
    end
  end

  test "GET /api/v1/location with token and location name returns 200 status code", %{conn: conn} do
    location_name = "Elbgold" |> URI.encode
    use_cassette "elbgold_search_location" do
      conn = conn
             |> guardian_login(insert(:user))
      response = get conn, "/api/v1/location?location_name=#{location_name}"
      assert response.status == 200
    end
  end

  test "GET /api/v1/location with token and location name returns latitude and longitude", %{conn: conn} do
    location_name = "Elbgold" |> URI.encode
    use_cassette "elbgold_search_location" do
      conn = conn
          |> guardian_login(insert(:user))
      response = get conn, "/api/v1/location?location_name=#{location_name}"
      results = response.resp_body |> Poison.decode! |> List.first
      assert Map.get(results, "description") == "Elbgold, Eppendorfer Baum, Hamburg, Germany"
      assert Map.get(results, "main_text") == "Elbgold"
      assert Map.get(results, "places_id") == "ChIJd6oNXsqIsUcRhkTvSBr6lSE"
    end
  end
end
