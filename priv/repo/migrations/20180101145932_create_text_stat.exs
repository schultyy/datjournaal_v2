defmodule Datjournaal.Repo.Migrations.CreateTextStat do
  use Ecto.Migration

  def change do
    create table(:text_stats) do
      add :unique_identifier, :string
      add :authenticated, :boolean, default: false, null: false
      add :text_post_id, references(:text_posts, on_delete: :nothing)

      timestamps()
    end
    create index(:text_stats, [:text_post_id])

  end
end
