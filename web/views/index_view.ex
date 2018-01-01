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

  def format_date(datetime) do
    Timex.format!(datetime, "%d.%m.%Y", :strftime)
  end

  def teaser_text(text) do
    teaser_char_length = 200
    if String.length(text) < teaser_char_length do
      text
    else
      String.slice(text, 0, teaser_char_length) <> "..."
    end
  end
end
