defmodule Datjournaal.StatTest do
  use Datjournaal.ModelCase

  alias Datjournaal.Stat

  @valid_attrs %{unique_identifier: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Stat.changeset(%Stat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Stat.changeset(%Stat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
