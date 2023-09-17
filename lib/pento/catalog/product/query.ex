defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base, do: Product

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  def join_ratings(query) do
    query
    |> join(:inner, [prod], r in Rating, on: r.product_id == prod.id)
  end

  def average_ratings(query) do
    query
    |> group_by([prod], prod.id)
    |> select([prod, rat], {prod.name, fragment("?::float", avg(rat.stars))})
  end
end
