defmodule Datjournaal.PostView do
  use Datjournaal.Web, :view
  def photo_url(post) do
    foo = Datjournaal.Image.url({post.image, :images}, :original)
          |> Path.basename
    "/uploads/" <> foo
  end
end