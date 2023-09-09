defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias __MODULE__.Component
  # before the mount callback fires, the on_mount function will fire
  # thus loading a user
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
