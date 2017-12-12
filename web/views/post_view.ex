defmodule Datjournaal.PostView do
  use Datjournaal.Web, :view
  use Timex
  import Scrivener.HTML

  def belongs_to_user?(post, user) do
    user && post.user_id == user.id
  end

  def photo_url(post, version) do
    foo = Datjournaal.Image.url({post.image, :images}, version)
          |> Path.basename
    "/uploads/" <> foo
  end

  def format_time(time) do
    Timex.format!(time, "%d.%m.%Y %H:%M", :strftime)
  end
end
