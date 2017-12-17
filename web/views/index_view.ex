defmodule Datjournaal.IndexView do
  use Datjournaal.Web, :view

  def photo_url(post, version) do
    foo = Datjournaal.Image.url({post.image, :images}, version)
          |> Path.basename
    "/uploads/" <> foo
  end
end
