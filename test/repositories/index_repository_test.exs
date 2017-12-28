defmodule Datjournaal.IndexRepositoryTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.IndexRepository

  test "returns both text and image posts ordered by date" do
    user = insert(:user)

    insert(:text_post, %{ user: user })
    :timer.sleep(1000)
    insert(:post, %{ user: user })

    all = IndexRepository.get_all()
    assert List.first(all).inserted_at < List.last(all).inserted_at
  end

  test "returns both text and image posts paginated" do
    user = insert(:user)
    insert_list(50, :text_post, %{ user: user })
    insert_list(50, :post, %{ user: user })
    all = IndexRepository.get_all(%{ page: 1, page_size: 25 })
    assert length(all) == 25
  end
end
