defmodule Datjournaal.Factory do
  use ExMachina.Ecto, repo: Datjournaal.Repo

  alias Comeonin.Bcrypt

  def user_factory do
    %Datjournaal.User {
      name: "Paul Hansen",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "test1234",
      password_hash: Bcrypt.hashpwsalt("test1234")
    }
  end
end