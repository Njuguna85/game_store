defmodule PentoWeb.Admin.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok,
     socket
     |> assign_user_activity()}
  end

  # fetch a list of products and their present users
  def assign_user_activity(socket) do
    assign(socket, :user_activity, Presence.list_products_and_users())
  end
end
