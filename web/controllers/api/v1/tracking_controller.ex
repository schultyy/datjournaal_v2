defmodule Datjournaal.TrackingController do
  use Datjournaal.Web, :controller

  alias Datjournaal.{Repo, ImagePost, TextPost}

  def log_image_visit(conn, %{ "id" => slug}) do
    Repo.get_by!(ImagePost, slug: slug)
    |> create_image_visit(conn)
    render(conn, "tracking.json", %{})
  end

  def log_text_visit(conn, %{ "id" => slug }) do
    Repo.get_by!(TextPost, slug: slug)
    |> create_text_visit(conn)
    render(conn, "tracking.json", %{})
  end

  defp create_image_visit(post, conn) do
    authenticated = conn.assigns.current_user != nil
    stats = Datjournaal.ImageStat.changeset(%Datjournaal.ImageStat{}, %{
      unique_identifier: retrieve_ip_address(conn),
      authenticated: authenticated,
      image_post_id: post.id
    })
    Repo.insert!(stats)
  end

  defp create_text_visit(post, conn) do
    authenticated = conn.assigns.current_user != nil
    stats = Datjournaal.TextStat.changeset(%Datjournaal.TextStat{}, %{
      unique_identifier: retrieve_ip_address(conn),
      authenticated: authenticated,
      text_post_id: post.id
    })
    Repo.insert!(stats)
  end

  defp retrieve_ip_address(conn) do
    ip_address = Plug.Conn.get_req_header(conn, "x-forwarded-for")
                  |> List.first
    case ip_address do
      nil -> "127.0.0.1"
      _ -> ip_address
    end
  end
end
