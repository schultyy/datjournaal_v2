defmodule Datjournaal.IndexController do
  use Datjournaal.Web, :controller
  alias Datjournaal.ImagePost

  def index(conn, params) do
    posts =
      ImagePost
      |> order_by(desc: :inserted_at)
      |> preload(:user)
      |> Repo.paginate(params)
    render conn,
          "index.html",
          posts: posts,
          page_number: posts.page_number,
          page_size: posts.page_size,
          total_pages: posts.total_pages,
          total_entries: posts.total_entries
  end

  def show(conn, %{"slug" => slug}) do
    post = Repo.get_by!(ImagePost, slug: slug) |> Repo.preload(:user)
    render(conn, "show.html", post: post)
  end
end
