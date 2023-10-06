defmodule Pento.Game.Board do
  @moduledoc """
  Is responsible for tracking a game.
  It will produce structs that describe the attributes of a board and implement a constructor function for creating new boards when a user starts the game of Pentiminoes.
  It will manage the behaviour of a board ie commands to select a pento to move, rotate, reflect, drop and more
  """
  alias Pento.Game.{Pentomino, Shape}

  # points make up the shape of the empty board that the user will fill up this pentominoes
  # completed_pentos is a list of pentominoes that the user has placed on the board
  # palette is the provided pentominoes that the user has available to solve the puzzle
  # active_pento is the currently selected pentomino that the user is moving
  defstruct active_pento: nil,
            completed_pentos: [],
            palette: [],
            points: []

  def puzzles(), do: ~w[default wide widest medium tiny]a

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))

  # create a board struct with a palette, points and correct
  # default values
  def new(palette, points) do
    %__MODULE__{palette: palette(palette), points: points}
  end

  # takes a board width and height and returns a
  # list of points that make up a rectangle of that size
  def rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:small), do: [:u, :v, :p]

  # create a new shape struct with a default color of :purple, name
  # of :board and the list of points that comprise the puzzel board
  def to_shape(board) do
    Shape.__struct__(color: :purple, name: :board, points: board.points)
  end

  # returns the list of all shapes that represent a full game
  # ie the board shape, the list of placed pentomino shapes and active
  # pentomino shape
  #
  #
  def to_shapes(board) do
    # the background shape
    board_shape = to_shape(board)
    # points to a list of the active pento, and completed pentos
    # that have already been placed on the puzzle board
    # reverse the order of the items
    # strip out the nils in case the active pento is not set
    # convert them into shapes
    # assemble the final list of shapes in the correct order for rendering
    pento_shapes =
      [board.active_pento | board.completed_pentos]
      |> Enum.reverse()
      |> Enum.filter(& &1)
      |> Enum.map(&Pentomino.to_shape/1)

    [board_shape | pento_shapes]
  end

  #
  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end

  def active?(%{active_pento: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false
end
