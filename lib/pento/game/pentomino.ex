defmodule Pento.Game.Pentomino do
  alias Pento.Game.Point
  alias Pento.Game.Shape

  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location {8, 8}

  @moduledoc """
  A user will be able to:
    - Rotate the pentomino in increments of 90 degrees
    - Flip the pentomino
    - Move the pentomino up, down, left, or right one square at a time
  """

  # hold the state of the pentomino as we transform the state from user
  defstruct name: :i, rotation: 0, reflected: false, location: @default_location

  def new(fields \\ []), do: __struct__(fields)

  # will take an argument of a pentomino and update its rotation attribute
  # in increments of 90 at a time.
  # It will return the value to 0 rather than exceeding 270
  def rotate(%{rotation: degrees} = p) do
    %{p | rotation: rem(degrees + 90, 360)}
  end

  # takes in a pentomino and return a new struct with updates :reflected value
  # which is opposite of the present value
  # if the pentomino is not flipped, reflected will be true
  defp flip(%{reflected: reflection} = p) do
    %{p | reflected: not reflection}
  end

  def up(p) do
    %{p | location: Point.move(p.location, {0, -1})}
  end

  def down(p) do
    %{p | location: Point.move(p.location, {0, 1})}
  end

  def left(p) do
    %{p | location: Point.move(p.location, {-1, 0})}
  end

  def right(p) do
    %{p | location: Point.move(p.location, {1, 0})}
  end

  # convert a pentomino to a shape
  def to_shape(pento) do
    Shape.new(pento.name, pento.rotation, pento.reflected, pento.location)
  end
end
