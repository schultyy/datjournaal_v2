defmodule Datjournaal.PostView do
  use Datjournaal.Web, :view
  use Timex

  def photo_url(post) do
    foo = Datjournaal.Image.url({post.image, :images}, :original)
          |> Path.basename
    "/uploads/" <> foo
  end

  def format_time(time) do
    Timex.format!(time, "%d.%m.%Y %H:%M", :strftime)
  end
end