defmodule Datjournaal.TextPostTest do
  use Datjournaal.ModelCase

  alias Datjournaal.TextPost

  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TextPost.changeset(%TextPost{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TextPost.changeset(%TextPost{}, @invalid_attrs)
    refute changeset.valid?
  end
end
