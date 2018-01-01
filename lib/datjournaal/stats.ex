defmodule Datjournaal.Stats do
  import Ecto.Changeset

  def unique_ip_address(changeset) do
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
