defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:Datjournaal)

    path = Application.app_dir(:Datjournaal, "priv/repo/migrations")

    Ecto.Migrator.run(MyApp.Repo, path, :up, all: true)

    :init.stop()
  end
end

