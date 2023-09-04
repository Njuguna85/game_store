defmodule PentoWeb.PromoLive do
  # pull live_view behaviour
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_recipient()
     |> assign_changeset()}
  end

  # add a Recipient struct in the socket
  def assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  # destructure the recipient from the socket
  # add a changeset to the socket to be used in the form
  def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, to_form(Promo.change_recipient(recipient)))
  end

  # handle_event accepts an event, the params and a socket
  # make sure the event is validate, and the params are of recipient
  # key in the dictionary, destructure the socket to get the recipient struct
  # remember the promo change_recipient creates a recipient changeset
  # and will only accept a recipient struct
  # we add the validate action to the changeset which is a signal that instructs phoenix to display errors
  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{
          assigns: %{recipient: recipient}
        } = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, to_form(changeset))}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    :timer.sleep(1000)
  end
end
