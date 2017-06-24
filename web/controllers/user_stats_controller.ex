defmodule Datjournaal.UserStatsController do
  use Datjournaal.Web, :controller

  alias Datjournaal.{Stat, Post}

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    p = my_posts(current_user)
    IO.inspect "MY POSTS"
    IO.inspect p
    render(conn, "index.html", my_posts: p)
  end

  defp my_posts(user) do
    my_posts = Repo.all(from p in Post, where: p.user_id == ^user.id, select: p.id)
    Repo.all(from stat in Stat, group_by: stat.post_id, where: stat.post_id in ^my_posts and stat.authenticated == false, select: {stat.post_id, count(stat.post_id)})
      |> Enum.map(fn({post_id, count}) -> { Repo.get!(Post, post_id), count } end)
      |> Enum.sort(fn({_p1, count1}, {_p2, count2}) -> count1 > count2 end)
  end
end
