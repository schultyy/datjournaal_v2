defmodule Datjournaal.Repo.Migrations.RenamePostsToImagePosts do
  use Ecto.Migration

  def change do
    rename table(:posts), to: table(:image_posts)
  end
end
