defmodule Datjournaal.UserStatsView do
  use Datjournaal.Web, :view

  def photo_url(post) do
    foo = Datjournaal.Image.url({post.image, :images}, :thumb)
          |> Path.basename
    "/uploads/" <> foo
  end
end
