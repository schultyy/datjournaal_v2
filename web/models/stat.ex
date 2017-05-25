defmodule Datjournaal.Stat do
  use Datjournaal.Web, :model

  schema "stats" do
    field :unique_identifier, :string
    field :authenticated, :boolean
    belongs_to :post, Datjournaal.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:unique_identifier, :authenticated])
    |> validate_required([:unique_identifier, :authenticated])
    |> unique_ip_address
  end

  defp unique_ip_address(changeset) do
    case changeset.valid? do
      true -> hash_address(changeset)
      false -> changeset
    end
  end

  defp hash_address(changeset) do
    address = changeset |> get_change(:unique_identifier)
    cond do
      address != nil ->
        unique_id = :crypto.hash(:sha256, address)
                    |> Base.encode16
        changeset |> put_change(:unique_identifier, unique_id)
      true -> changeset
    end
  end
end
