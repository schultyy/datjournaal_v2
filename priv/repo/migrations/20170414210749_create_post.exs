defmodule Datjournaal.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :description, :string
      add :image, :string
      add :slug, :string

      timestamps()
    end

  end
end
