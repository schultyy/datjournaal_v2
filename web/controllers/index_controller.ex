defmodule Datjournaal.IndexController do
  use Datjournaal.Web, :controller
  alias Datjournaal.{TextPost, ImagePost, IndexRepository}

  def index(conn, params) do
    posts = IndexRepository.get_all(params)

    render conn,
          "index.html",
          posts: posts
  end

  def show_image(conn, %{"slug" => slug}) do
    post = Repo.get_by!(ImagePost, slug: slug) |> Repo.preload(:user)
    render(conn, "show_image.html", post: post)
  end

  def show_text(conn, %{"slug" => slug}) do
    post = Repo.get_by!(TextPost, slug: slug) |> Repo.preload(:user)
    render(conn, "show_text.html", post: post)
  end

  def show_legacy(conn, %{"slug" => _slug} = params), do: show_image(conn, params)
end
