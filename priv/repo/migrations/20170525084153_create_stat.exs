defmodule Datjournaal.Repo.Migrations.CreateStat do
  use Ecto.Migration

  def change do
    create table(:stats) do
      add :unique_identifier, :string
      add :authenticated, :bool
      add :post_id, references(:posts, on_delete: :nothing)

      timestamps()
    end
    create index(:stats, [:post_id])

  end
end
