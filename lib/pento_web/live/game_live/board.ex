defmodule PentoWeb.GameLive.Board do
  use PentoWeb, :live_component
  alias Pento.Game.{Board, Pentomino}
  import PentoWeb.GameLive.{Colors, Component}

  @moduledoc """
  The boards holds the logical representation of the game, and
  the list of shapes that will render
  """

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_shapes()}
  end

  def assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  # will track the conceptual state of the game
  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    active = Pentomino.new(name: :p, location: {7, 2})

    completed = [
      Pentomino.new(name: :u, rotation: 270, location: {1, 2}),
      Pentomino.new(name: :v, rotation: 90, location: {4, 2})
    ]

    board =
      puzzle
      |> String.to_existing_atom()
      |> Board.new()
      |> Map.put(:completed_pentos, completed)
      |> Map.put(:active_pento, active)

    assign(socket, board: board)
  end

  # represents the data to be rendered
  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shape = Board.to_shape(board)
    assign(socket, shapes: [shape])
  end

  def render(assigns) do
    ~H"""
    <div id={@id} phx-window-keydown="key" phx-target={@myself}>
      <.canvas view_box="0 0 200 70">
        <%= for shape <- @shapes do %>
          <.shape
            points={shape.points}
            fill={color(shape.color, Board.active?(@board, shape.name), false)}
            name={shape.name}
          />
        <% end %>
      </.canvas>
      <hr />
      <.palette
        shape_names={@board.palette}
        completed_shape_names={Enum.map(@board.completed_pentos, & &1.name)}
      />
    </div>
    """
  end
end