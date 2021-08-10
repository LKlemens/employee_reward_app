defmodule EmployeeRewardApp.Reward do
  @moduledoc """
  The Reward context.
  """

  import Ecto.Query, warn: false
  alias EmployeeRewardApp.Repo

  alias EmployeeRewardApp.Reward.Points.Point

  @doc """
  Returns the list of points.

  ## Examples

      iex> list_points()
      [%Point{}, ...]

  """
  def list_points do
    raise "TODO"
  end

  @doc """
  Gets a single point.

  Raises if the Point does not exist.

  ## Examples

      iex> get_point!(123)
      %Point{}

  """
  def get_point!(id), do: raise "TODO"

  @doc """
  Creates a point.

  ## Examples

      iex> create_point(%{field: value})
      {:ok, %Point{}}

      iex> create_point(%{field: bad_value})
      {:error, ...}

  """
  def create_point(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a point.

  ## Examples

      iex> update_point(point, %{field: new_value})
      {:ok, %Point{}}

      iex> update_point(point, %{field: bad_value})
      {:error, ...}

  """
  def update_point(%Point{} = point, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, ...}

  """
  def delete_point(%Point{} = point) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking point changes.

  ## Examples

      iex> change_point(point)
      %Todo{...}

  """
  def change_point(%Point{} = point, _attrs \\ %{}) do
    raise "TODO"
  end
end
