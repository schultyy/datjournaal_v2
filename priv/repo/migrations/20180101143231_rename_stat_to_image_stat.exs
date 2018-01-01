defmodule Datjournaal.Repo.Migrations.RenameStatToImageStat do
  use Ecto.Migration

  def change do
    rename table(:stats), to: table(:image_stats)
  end
end
