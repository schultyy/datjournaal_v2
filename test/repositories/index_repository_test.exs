defmodule Datjournaal.IndexRepositoryTest do
  use Datjournaal.ConnCase
  import Datjournaal.Factory

  alias Datjournaal.IndexRepository

  test "returns both text and image posts ordered by date" do
    user = insert(:user)

    text_post = insert(:text_post, %{ user: user })
    :timer.sleep(1000)
    image_post = insert(:post, %{ user: user })

    all = IndexRepository.get_all()
    assert List.first(all).id == text_post.id
    assert List.last(all).id == image_post.id
  end
end
