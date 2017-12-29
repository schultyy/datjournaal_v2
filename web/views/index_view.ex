defmodule Datjournaal.IndexView do
  use Datjournaal.Web, :view
  use Timex

  def photo_url(post, version) do
    image_url = Datjournaal.Image.url({post.image, :images}, version)
          |> Path.basename
    "/uploads/" <> image_url
  end

  def belongs_to_user?(post, user) do
    user && post.user_id == user.id
  end

  def format_time(time) do
    Timex.format!(time, "%d.%m.%Y %H:%M", :strftime)
  end

  def teaser_text(text) do
    if String.length(text) < 100 do
      text
    else
      String.slice(text, 0, 100) <> "..."
    end
  end
end
