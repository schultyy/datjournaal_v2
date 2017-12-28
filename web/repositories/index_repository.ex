defmodule Datjournaal.IndexRepository do
  import Ecto.Query
  alias Datjournaal.ImagePost
  alias Datjournaal.TextPost
  alias Datjournaal.Repo

  def get_all(params) do
    pagination_config = maybe_put_default_config(params)

    image_posts =
      ImagePost
      |> order_by(desc: :inserted_at)
      |> preload(:user)
      |> Repo.paginate(params)

    text_posts =
      TextPost
      |> order_by(desc: :inserted_at)
      |> preload(:user)
      |> Repo.paginate(params)

    all_posts = Enum.concat(image_posts, text_posts)
    Enum.sort_by(all_posts, &(&1.inserted_at))
    |> Scrivener.paginate(pagination_config)
  end

  def get_all() do
    image_posts =
      ImagePost
      |> order_by(desc: :inserted_at)
      |> preload(:user)

    text_posts =
      TextPost
      |> order_by(desc: :inserted_at)
      |> preload(:user)

    all_posts = Enum.concat(Repo.all(image_posts), Repo.all(text_posts))
    Enum.sort_by(all_posts,  &(&1.inserted_at))
  end

  defp maybe_put_default_config(%{page: _page_number, page_size: _page_size} = params), do: params
  defp maybe_put_default_config(_params), do: %Scrivener.Config{page_number: 1, page_size: 10}
end
