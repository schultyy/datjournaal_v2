defmodule Datjournaal.Repo.Migrations.AddLocationFieldsToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :lat, :float, default: nil
      add :lng, :float, default: nil
      add :places_id, :string
      add :short_location_name, :string
      add :long_location_name, :string
    end
  end
end
