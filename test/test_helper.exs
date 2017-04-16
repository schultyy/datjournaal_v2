Enum.each([:ex_machina], fn(app) ->
  Application.ensure_all_started(app)
end)

ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Datjournaal.Repo, :manual)

