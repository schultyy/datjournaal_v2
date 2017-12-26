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

  def post_factory do
    %Datjournaal.ImagePost {
      description: "Dies, Das",
      image: %Plug.Upload{ path: "test/fixtures/placeholder.jpg", filename: "placeholder.jpg" },
      user: build(:user),
      slug: "12345"
    }
  end

  def text_post_factory do
    %Datjournaal.TextPost {
      content: "Dies, Das, Ananas",
      title: "Dieses und jenes",
      user: build(:user)
    }
  end
end
