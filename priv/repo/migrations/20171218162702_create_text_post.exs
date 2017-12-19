defmodule Datjournaal.Repo.Migrations.CreateTextPost do
  use Ecto.Migration

  def change do
    create table(:text_posts) do
      add :title, :string
      add :content, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:text_posts, [:user_id])

  end
end
