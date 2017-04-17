defmodule Datjournaal.PostController do
  use Datjournaal.Web, :controller

  alias Datjournaal.Post

  def index(conn, _params) do
    posts = Repo.all from p in Post,
        order_by: [desc: p.inserted_at],
        select: p,
        limit: 50
    posts_with_users = Repo.preload(posts, :user)
    render(conn, "index.html", posts: posts_with_users)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user

    changeset = current_user
                |> build_assoc(:posts)
                |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    post = Repo.get_by!(Post, slug: slug) |> Repo.preload(:user)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    post = Repo.get!(Post, id)

    cond do
      post.user_id == current_user.id ->
        Repo.delete!(post)
        conn
        |> put_flash(:info, "Post deleted successfully.")
        |> redirect(to: post_path(conn, :index))
      true ->
        conn
        |> put_flash(:error, "You cannot delete posts which don't belong to you")
        |> redirect(to: post_path(conn, :show, post.slug))
    end
  end
end
