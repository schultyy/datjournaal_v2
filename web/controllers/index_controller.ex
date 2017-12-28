defmodule Datjournaal.IndexController do
  use Datjournaal.Web, :controller
  alias Datjournaal.{ImagePost, IndexRepository}

  def index(conn, params) do
    posts = IndexRepository.get_all(params)

    render conn,
          "index.html",
          posts: posts,
          page_number: posts.page_number,
          page_size: posts.page_size,
          total_pages: posts.total_pages,
          total_entries: posts.total_entries
  end

  def show_image(conn, %{"slug" => slug}) do
    post = Repo.get_by!(ImagePost, slug: slug) |> Repo.preload(:user)
    render(conn, "show.html", post: post)
  end

  def show_legacy(conn, %{"slug" => _slug} = params), do: show_image(conn, params)
end
