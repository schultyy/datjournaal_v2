defmodule Datjournaal.Repo.Migrations.CreateTwitterKey do
  use Ecto.Migration

  def change do
    create table(:twitterkeys) do
      add :name, :string
      add :screen_name, :string
      add :access_token, :string
      add :access_token_secret, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:twitterkeys, [:user_id])

  end
end
