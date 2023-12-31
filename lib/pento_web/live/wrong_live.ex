defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts

  def mount(_params, session, socket) do
    {:ok,
     assign(
       socket,
       score: 0,
       message: "Make a guess:",
       session_id: session["live_socket_id"]
     )}
  end

  def render(assigns) do
    ~H"""
    <h1>Your Score: <%= @score %></h1>
    <h2>
      <%= @message %>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again."
    score = socket.assigns.score(-1)

    {
      :noreply,
      assign(
        socket,
        score: score,
        message: message
      )
    }
  end
end
