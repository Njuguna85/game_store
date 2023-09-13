defmodule PentoWeb.SurveyLive do
  alias Pento.Survey
  alias PentoWeb.DemographicLive
  alias PentoWeb.RatingLive
  alias Pento.Catalog

  # add the SurveyLive function component
  # now we can use this in the SurveyLive template
  alias __MODULE__.Component

  use PentoWeb, :live_view
  # before the mount callback fires, the on_mount function will fire
  # thus loading a user
  # After an on_mount callback runs and the mount finishes, the live view
  # will render, if render/1 is not provided, survey_live.html.heex will run
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_demographic()
     |> assign_products()}
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end

  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_rating(user)
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  # notify the user that the save was successful
  # store the demographic in the socket
  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end
end
