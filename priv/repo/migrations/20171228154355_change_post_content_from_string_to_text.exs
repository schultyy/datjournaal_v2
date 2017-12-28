defmodule Datjournaal.Repo.Migrations.ChangePostContentFromStringToText do
  use Ecto.Migration

  def change do
    alter table(:text_posts) do
      modify :content, :text
    end
  end
end
