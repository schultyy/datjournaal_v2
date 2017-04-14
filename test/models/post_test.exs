defmodule Datjournaal.PostTest do
  use Datjournaal.ModelCase

  alias Datjournaal.Post

  @valid_attrs %{description: "some content", image: "some content", slug: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
