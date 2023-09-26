defmodule PentoWeb.Presence do
  alias PentoWeb.Presence
  # the args are the otp application and the publish/subscribe server
  use Phoenix.Presence, otp_app: :pento, pubsub_server: Pento.PubSub

  # this defines a presence model, which is
  # 1. the data structure that tracks information about active users on our site
  # 2. the functions that process changes in the model
  @user_activity_topic "user_activity"

  def track_user(pid, product, user_email) do
    Presence.track(
      pid,
      @user_activity_topic,
      product.name,
      %{users: [%{email: user_email}]}
    )
  end

  def list_products_and_users do
    Presence.list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    Enum.map(metas_list, &users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  def users_from_meta_map(meta_map) do
    get_in(meta_map, [:users])
  end
end
