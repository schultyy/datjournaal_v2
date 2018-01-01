defmodule Datjournaal.StatTest do
  use Datjournaal.ModelCase

  alias Datjournaal.ImageStat

  @valid_attrs %{unique_identifier: "192.16.23.12", authenticated: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ImageStat.changeset(%ImageStat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "it hashes the user's IP address" do
    changeset = ImageStat.changeset(%ImageStat{}, @valid_attrs)
    assert changeset |> get_field(:unique_identifier) == "D8F8A9039D790B53C11642BBA486355D63524C59F4FC6F29301644157D954AA7"
  end

  test "changeset with invalid attributes" do
    changeset = ImageStat.changeset(%ImageStat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
