defmodule Datjournaal.LocationView do
  use Datjournaal.Web, :view

  def render("location.json", %{ "predictions" => predictions }) do
    predictions
      |> Enum.map(&render_prediction/1)
  end

  defp render_prediction(prediction) do
    %{
      "description": Map.get(prediction, "description"),
      "places_id": Map.get(prediction, "place_id"),
      "main_text": Map.get(prediction, "structured_formatting") |> Map.get("main_text")
    }
  end
end