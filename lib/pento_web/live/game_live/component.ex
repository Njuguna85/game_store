defmodule PentoWeb.GameLive.Component do
  use Phoenix.Component

  alias Pento.Game.Pentomino
  import PentoWeb.GameLive.Colors

  attr :x, :integer, required: true
  attr :y, :integer, required: true
  attr :fill, :string
  attr :name, :string
  attr :"phx-click", :string
  attr :"phx-value", :string
  attr :"phx-target", :any

  def point(assigns) do
    ~H"""
    <use
      xlink:href="#point"
      x={convert(@x)}
      y={convert(@y)}
      fill={@fill}
      phx-click="pick"
      phx-value-name={@name}
      phx-target="#game"
    />
    """
  end

  def width, do: 10

  # takes in the value of the x or y coordinate
  # does the math to build the x and o offsets of the square
  # it serves to center each pentomino within its 5X5 box
  # i-1 is important because x n y values pentominoes start at 1
  # but the values on our canvas will start at 0
  def convert(i) do
    (i - 1) * width() + 2 * width()
  end

  # will define an SVG viewport
  # define the reusable <rect>
  # provide a slot to render custom content based on state of game
  attr :view_box, :string
  slot :inner_block, required: true

  def canvas(assigns) do
    ~H"""
    <svg viewBox={@view_box}>
      <defs>
        <rect id="point" width="10" height="10" />
      </defs>
      <%= render_slot(@inner_block) %>
    </svg>
    """
  end

  attr :points, :list, required: true
  attr :name, :string, required: true
  attr :fill, :string, required: true

  def shape(assigns) do
    ~H"""
    <%= for{x, y} <- @points do %>
      <.point x={x} y={y} fill={@fill} name={@name} />
    <% end %>
    """
  end

  attr :shape_names, :list, required: true
  attr :completed_shape_names, :list, default: []

  def palette(assigns) do
    ~H"""
    <div id="palette">
      <.canvas view_box="0 0 500 125">
        <%= for shape <- palette_shapes(@shape_names) do %>
          <.shape
            points={shape.points}
            fill={color(shape.color, false, shape.name in @completed_shape_names)}
            name={shape.name}
          />
        <% end %>
      </.canvas>
    </div>
    """
  end

  defp palette_shapes(names) do
    names
    |> Enum.with_index()
    |> Enum.map(&place_pento/1)
  end

  defp place_pento({name, index}) do
    Pentomino.new(name: name, location: location(index))
    |> Pentomino.to_shape()
  end

  defp location(i) do
    x = rem(i, 6) * 4 + 3
    y = div(i, 6) * 5 + 3
    {x, y}
  end

  attr :view_box, :string

  def control_panel(assigns) do
    ~H"""
    <svg viewBox={@view_box}>
      <defs>
        <rect id="point" width="10" height="10" />
      </defs>
      <%= render_slot(@inner_block) %>
    </svg>
    """
  end
end
