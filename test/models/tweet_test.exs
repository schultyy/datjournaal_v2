defmodule Datjournaal.TweetTest do
  use Datjournaal.ModelCase

  alias Datjournaal.{Tweet, ImagePost}

  test "generates correct url for post" do
    post = %ImagePost{slug: UUID.uuid4(:hex)}
    assert Tweet.to_url(post) == "http://datjournaal.de/#{post.slug}"
  end

  test "Tweet with long text stays within 140 char limit" do
    post = %{slug: UUID.uuid4(:hex), text: "Wayfarers minim umami, do gochujang quinoa forage banh mi art party. Waistcoat yr blue bottle, shoreditch leggings accusamus wolf tattooed migas nostrud. Sint id celiac, mollit neutra direct trade woke activated charcoal qui tote bag authentic dreamcatcher. Tilde fap portland intelligentsia sunt velit. Hexagon magna commodo, sriracha unicorn locavore craft beer put a bird on it subway tile. Quis do cornhole kale chips jean shorts. Proident enim ugh non, stumptown pabst blog venmo VHS raw denim lomo."}
    url = post |> Tweet.to_url
    assert String.length(Tweet.to_tweet(url, post.text)) <= 140
  end

  test "Tweet with short text is not shortened" do
    tweet_text = "Amsterdam Centraal, mit Zug"
    post = %{slug: UUID.uuid4(:hex), text: tweet_text}
    url = post |> Tweet.to_url
    text = Tweet.to_tweet(url, post.text)
          |> String.split("\n")
          |> List.first
    assert text == "📸 " <> tweet_text
  end

  test "Tweet with short text does not contain three dots" do
    post = %{slug: UUID.uuid4(:hex), text: "Amsterdam Centraal, mit Zug"}
    url = post |> Tweet.to_url
    assert String.contains?(Tweet.to_tweet(url, post.text), "...") == false
  end

  test "Tweet starts with camera emoji" do
    post = %{slug: UUID.uuid4(:hex), text: "Amsterdam Centraal, mit Zug"}
    url = post |> Tweet.to_url
    assert String.first(Tweet.to_tweet(url, post.text)) == "📸"
  end

  test "Tweet where text is nil does not crash" do
    post = %{slug: UUID.uuid4(:hex), text: nil}
    url = post |> Tweet.to_url
    assert Tweet.to_tweet(url, post.text) == "📸 \n#{url}"
  end

  test "Location shall be included in the tweet" do
    post = %{slug: UUID.uuid4(:hex), text: "Lorem ipsum dolor sit amet", location: "Hamburg, CCH"}
    url = post |> Tweet.to_url
    assert String.contains?(Tweet.to_tweet(url, post.text, post.location), "@ Hamburg, CCH")
  end

  test "Location shall be included in the tweet with very long text" do
    post = %{slug: UUID.uuid4(:hex), text: "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet", location: "Hamburg, CCH"}
    url = post |> Tweet.to_url
    assert String.contains?(Tweet.to_tweet(url, post.text, post.location), "@ Hamburg, CCH")
    assert String.contains?(Tweet.to_tweet(url, post.text, post.location), url)
  end

  test "Tweet contains just the location when text is empty" do
    post = %{slug: UUID.uuid4(:hex), text: "", location: "Hamburg, CCH"}
    url = post |> Tweet.to_url
    assert String.contains?(Tweet.to_tweet(url, post.text, post.location), "📸 @ Hamburg, CCH")
  end

  test "Tweet where location is nil should generate normal tweet" do
    post = %{slug: UUID.uuid4(:hex), text: "Lorem ipsum dolor sit amet", location: nil}
    url = post |> Tweet.to_url
    assert Tweet.to_tweet(url, post.text, post.location) == "📸 Lorem ipsum dolor sit amet\n#{url}"
  end

  test "Tweet with location where text is nil should generate tweet" do
    post = %{slug: UUID.uuid4(:hex), text: nil, location: "Hamburg, CCH"}
    url = post |> Tweet.to_url
    assert Tweet.to_tweet(url, post.text, post.location) == "📸 @ Hamburg, CCH\n#{url}"
  end

  test "Tweet where location is nil and where text is nil should generate tweet with url" do
    post = %{slug: UUID.uuid4(:hex), text: nil, location: nil}
    url = post |> Tweet.to_url
    assert Tweet.to_tweet(url, post.text, post.location) == "📸 \n#{url}"
  end
end
