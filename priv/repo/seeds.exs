# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Datjournaal.Repo.insert!(%Datjournaal.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Datjournaal.{Repo, User}

[
  %{
    name: "schultyy",
    email: "hello@unexpected-co.de",
    password: "test1234"
  }
]
|> Enum.map(&User.changeset(%User{}, &1))
|> Enum.each(&Repo.insert!(&1))
