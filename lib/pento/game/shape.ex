defmodule Pento.Game.Shape do
  @moduledoc """
    Is responsible for modelling pentomino shapes

    Each shape has a distinct color and list of points
  """

  alias Pento.Game.Point

  # the keys and default values
  defstruct color: :blue, name: :x, points: []

  # colors associated with each shape
  defp color(:i), do: :dark_green
  defp color(:l), do: :green
  defp color(:y), do: :light_green
  defp color(:n), do: :dark_orange
  defp color(:p), do: :orange
  defp color(:w), do: :light_orange
  defp color(:u), do: :dark_gray
  defp color(:v), do: :gray
  defp color(:s), do: :light_gray
  defp color(:f), do: :dark_blue
  defp color(:x), do: :blue
  defp color(:t), do: :light_blue

  # points that make each shape
  defp points(:i), do: [{3, 1}, {3, 2}, {3, 3}, {3, 4}, {3, 5}]
  defp points(:l), do: [{3, 1}, {3, 2}, {3, 3}, {3, 4}, {4, 4}]
  defp points(:y), do: [{3, 1}, {2, 2}, {3, 2}, {3, 3}, {3, 4}]
  defp points(:n), do: [{3, 1}, {3, 2}, {3, 3}, {4, 3}, {4, 4}]
  defp points(:p), do: [{3, 2}, {4, 3}, {3, 3}, {4, 2}, {3, 4}]
  defp points(:w), do: [{2, 2}, {2, 3}, {3, 3}, {3, 4}, {4, 4}]
  defp points(:u), do: [{2, 2}, {4, 2}, {2, 3}, {3, 3}, {4, 3}]
  defp points(:v), do: [{2, 2}, {2, 3}, {2, 4}, {3, 4}, {4, 4}]
  defp points(:s), do: [{3, 2}, {4, 2}, {3, 3}, {2, 4}, {3, 4}]
  defp points(:f), do: [{3, 2}, {4, 2}, {2, 3}, {3, 3}, {3, 4}]
  defp points(:x), do: [{3, 2}, {2, 3}, {3, 3}, {4, 3}, {3, 4}]
  defp points(:t), do: [{2, 2}, {3, 2}, {4, 2}, {3, 3}, {3, 4}]

  # a shape is constructed with a provided name, rotation,
  # reflection and location
  # Get a list of points that make up the given shape
  # iterate the points and apply the provided rotation, reflection, and location
  # to each point
  # return a shape struct that knows its name, color and updated list of points
  def new(name, rotation, reflected, location) do
    points =
      name
      |> points()
      |> Enum.map(&Point.prepare(&1, rotation, reflected, location))

    # the capture operator(&) defines an anonymous function that takes in
    # one argument (&1) and is used to apply the Point.prepare/4 function

    %__MODULE__{points: points, color: color(name), name: name}
  end
end
