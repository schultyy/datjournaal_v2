defmodule Datjournaal.UserStatsController do
  use Datjournaal.Web, :controller

  alias Datjournaal.{ImageStat, ImagePost, TextPost, TextStat}

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    render(conn, "index.html", my_image_posts: my_image_posts(current_user), my_text_posts: my_text_posts(current_user))
  end

  defp my_image_posts(user) do
    my_posts = Repo.all(from p in ImagePost, where: p.user_id == ^user.id, select: p.id)
    Repo.all(from stat in ImageStat, group_by: stat.image_post_id, where: stat.image_post_id in ^my_posts and stat.authenticated == false, select: {stat.image_post_id, count(stat.image_post_id)})
      |> Enum.map(fn({post_id, count}) -> { Repo.get!(ImagePost, post_id), count } end)
      |> Enum.sort(fn({_p1, count1}, {_p2, count2}) -> count1 > count2 end)
  end

  defp my_text_posts(user) do
    my_posts = Repo.all(from p in TextPost, where: p.user_id == ^user.id, select: p.id)
    Repo.all(from stat in TextStat, group_by: stat.text_post_id, where: stat.text_post_id in ^my_posts and stat.authenticated == false, select: {stat.text_post_id, count(stat.text_post_id)})
      |> Enum.map(fn({post_id, count}) -> { Repo.get!(TextPost, post_id), count } end)
      |> Enum.sort(fn({_p1, count1}, {_p2, count2}) -> count1 > count2 end)
  end
end
