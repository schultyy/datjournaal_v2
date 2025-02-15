defmodule Datjournaal.TextPostController do
  use Datjournaal.Web, :controller

  alias Datjournaal.TextPost

  def new(conn, _params) do
    changeset = TextPost.changeset(%TextPost{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"text_post" => text_post_params}) do
    current_user = conn.assigns.current_user

    changeset = current_user
                |> build_assoc(:text_posts)
                |> TextPost.changeset(text_post_params)

    case Repo.insert(changeset) do
      {:ok, _text_post} ->
        conn
        |> put_flash(:info, "Text post created successfully.")
        |> redirect(to: index_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    text_post = Repo.get!(TextPost, id)
    changeset = TextPost.changeset(text_post)
    render(conn, "edit.html", text_post: text_post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "text_post" => text_post_params}) do
    text_post = Repo.get!(TextPost, id)
    changeset = TextPost.changeset(text_post, text_post_params)

    case Repo.update(changeset) do
      {:ok, text_post} ->
        conn
        |> put_flash(:info, "Text post updated successfully.")
        |> redirect(to: index_path(conn, :show_text, text_post))
      {:error, changeset} ->
        render(conn, "edit.html", text_post: text_post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    text_post = Repo.get!(TextPost, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(text_post)

    conn
    |> put_flash(:info, "Text post deleted successfully.")
    |> redirect(to: index_path(conn, :index))
  end
end
