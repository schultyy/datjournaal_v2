defmodule Datjournaal.Repo.Migrations.AddSlugToTextPost do
  use Ecto.Migration

  def change do
    alter table(:text_posts) do
      add :slug, :string
    end
  end
end
