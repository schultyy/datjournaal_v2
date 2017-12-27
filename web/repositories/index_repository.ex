defmodule Datjournaal.IndexRepository do
  import Ecto.Query
  alias Datjournaal.ImagePost
  alias Datjournaal.TextPost
  alias Datjournaal.Repo

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
end
