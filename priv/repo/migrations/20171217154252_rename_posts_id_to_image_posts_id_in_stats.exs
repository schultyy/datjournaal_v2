defmodule Datjournaal.Repo.Migrations.RenamePostsIdToImagePostsIdInStats do
  use Ecto.Migration

  def change do
    rename table(:stats), :post_id, to: :image_post_id
  end
end
