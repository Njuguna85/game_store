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

  def puzzles(), do: ~w[tiny small ball donut default wide widest medium]a

  def new(:tiny), do: new(:small, rect(5, 3))
  def new(:widest), do: new(:all, rect(20, 3))
  def new(:wide), do: new(:all, rect(15, 4))
  def new(:medium), do: new(:all, rect(12, 5))
  def new(:default), do: new(:all, rect(10, 6))
  def new(:small), do: new(:medium, rect(7, 5))

  def new(:donut) do
    new(:all, rect(8, 8), for(x <- 4..5, y <- 4..5, do: {x, y}))
  end

  def new(:ball) do
    new(:all, rect(8, 8), for(x <- [1, 8], y <- [1, 8], do: {x, y}))
  end

  # create a board struct with a palette, points and
  # correct default values
  def new(palette, points, hole \\ []) do
    %__MODULE__{palette: palette(palette), points: points -- hole}
  end

  # takes a board width and height and returns a
  # list of points that make up a rectangle of that size
  def rect(x, y) do
    for x <- 1..x, y <- 1..y, do: {x, y}
  end

  # a palette defines the list of shapes allowed in a puzzle
  defp palette(:all), do: [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  defp palette(:small), do: [:u, :v, :p]
  defp palette(:medium), do: [:t, :y, :l, :p, :n, :v, :u]

  # create a new shape struct with a default color of :purple, name
  # of :board and the list of points that comprise the puzzle board
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

  # given a board an a pento on that board, tell us if
  # that pento is the active one
  def active?(board, shape_name) when is_binary(shape_name) do
    active?(board, String.to_existing_atom(shape_name))
  end

  def active?(%{active_pento: %{name: shape_name}}, shape_name), do: true
  def active?(_board, _shape_name), do: false

  # ignore the user action as the clicks are on the board
  def pick(board, :board), do: board

  # user click on pentomino, but an active pentomino is already selected, if they click on the active one, we release it.
  def pick(%{active_pento: pento} = board, shape_name) when not is_nil(pento) do
    if pento.name == shape_name do
      %{board | active_pento: nil}
    else
      board
    end
  end

  # user picks up a pentomino, it might be one that has already been solved, if so, we remove it from the completed list and let them place it again. if not, we make it the active pentomino
  def pick(board, shape_name) do
    active =
      board.completed_pentos
      |> Enum.find(&(&1.name == shape_name))
      |> Kernel.||(new_pento(board, shape_name))

    completed = Enum.filter(board.completed_pentos, &(&1.name != shape_name))

    %{board | active_pento: active, completed_pentos: completed}
  end

  defp new_pento(board, shape_name) do
    Pentomino.new(name: shape_name, location: midpoints(board))
  end

  defp midpoints(board) do
    {xs, ys} = Enum.unzip(board.points)
    {midpoint(xs), midpoint(ys)}
  end

  defp midpoint(i), do: round(Enum.max(i) / 2.0)

  def legal_drop?(%{active_pento: pento}) when is_nil(pento), do: false

  def legal_drop?(%{active_pento: pento, points: board_points} = board) do
    points_on_board =
      Pentomino.to_shape(pento).points
      |> Enum.all?(fn point -> point in board_points end)

    no_overlapping_pentos = !Enum.any?(board.completed_pentos, &overlapping?(pento, &1))

    points_on_board and no_overlapping_pentos
  end

  def legal_move?(%{active_pento: pento, points: points} = _board) do
    pento.location in points
  end

  def overlapping?(pento1, pento2) do
    {p1, p2} = {to_shape(pento1).points, to_shape(pento2).points}
    Enum.count(p1 -- p2) != 5
  end

  # drop the active pento

  # there is no active pento to drop
  def drop(%{active_pento: nil} = board), do: board

  def drop(%{active_pento: pento} = board) do
    board
    |> Map.put(:active_pento, nil)
    |> Map.put(:completed_pentos, [pento | board.completed_pentos])
  end
end
