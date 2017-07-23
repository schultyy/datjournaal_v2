defmodule Datjournaal.TrackingView do
  use Datjournaal.Web, :view

  def render("tracking.json", %{}) do
    %{
      status: "ok"
    }
  end
end
