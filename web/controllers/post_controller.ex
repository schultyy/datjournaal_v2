defmodule Datjournaal.PostController do
  use Datjournaal.Web, :controller
  import Ecto.Changeset
  alias Datjournaal.Post

  plug :scrub_params, "post" when action in [:create]

  def index(conn, _params) do
    posts = Repo.all from p in Post,
        order_by: [desc: p.inserted_at],
        select: p,
        limit: 50
    posts_with_users = Repo.preload(posts, :user)
    render(conn, "index.html", posts: posts_with_users)
  end

  def new(conn, _params) do
    current_user = conn.assigns.current_user
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", %{changeset: changeset, current_user: Repo.preload(current_user, :twitterkey)})
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user

    changeset = current_user
                |> build_assoc(:posts)
                |> Post.changeset(post_params)
                |> fetch_location

    create_tweet = Map.get(post_params, "post_on_twitter")

    case Repo.insert(changeset) do
      {:ok, post} ->
        post_with_user = Repo.preload(post, user: :twitterkey)
        post_to_twitter(create_tweet, post_with_user)
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", %{ changeset: changeset, current_user: Repo.preload(current_user, :twitterkey) })
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

  defp post_to_twitter("true", post_with_user) do
    key = post_with_user.user.twitterkey
    case key do
      nil -> {}
      _   ->
        ExTwitter.configure(
          :process,
          Enum.concat(
            ExTwitter.Config.get_tuples,
            [ access_token: key.access_token,
              access_token_secret: key.access_token_secret ]
          )
        )
        Datjournaal.Tweet.to_url(post_with_user)
            # This has to stay disabled until we add location support for Dat Journaal
            # |> Datjournaal.Tweet.to_tweet(post_with_user.description, post_with_user.long_location_name)
            # So long we will go with just the tweet's description
            |> Datjournaal.Tweet.to_tweet(post_with_user.description)
            |> ExTwitter.update()
    end
  end

  defp post_to_twitter(_post_on_twitter, _post_with_user) do
    {}
  end

  defp fetch_location(changeset) do
    places_id = changeset |> get_change(:places_id)

    cond do
      places_id != nil ->
        case Datjournaal.GmapsApiClient.get_place_details(places_id) do
          { lat, long, long_name, short_name } ->
            changeset
              |> put_change(:short_location_name, short_name)
              |> put_change(:long_location_name, long_name)
              |> put_change(:lat, lat)
              |> put_change(:lng, long)
          nil -> changeset |> add_error(:places_id, "Invalid Google Places ID")
        end
      true -> changeset
    end
  end
end
