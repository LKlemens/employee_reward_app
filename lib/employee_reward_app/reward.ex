defmodule EmployeeRewardApp.Reward do
  @moduledoc """
  The Reward context.
  """

  import Ecto.Query, warn: false
  alias EmployeeRewardApp.Repo

  alias EmployeeRewardApp.Reward.Points
  alias EmployeeRewardApp.Accounts
  alias EmployeeRewardApp.Reward.Points.Point

  @doc """
  Returns the list of users with points.

  ## Examples

      iex> list_users()
      [%User{points: val, ...}, ...]

  """
  def list_users do
    Accounts.get_users_with_point()
  end

  @doc """
  Returns the list of points.

  ## Examples

      iex> list_points()
      [%Point{}, ...]

  """
  def list_points do
    Points.list_points()
  end

  @doc """
  Gets a single point.

  Raises if the Point does not exist.

  ## Examples

      iex> get_point!(123)
      %User{}

  """
  def get_user(id) do
    Accounts.get_user_with_point(id)
  end

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
  def update_point(%Point{} = point, %{"pool" => _pool, "received" => _received} = params) do
    Repo.get_by(Point, user_id: point.user_id)
    |> Point.changeset(params)
    |> Repo.update()
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
    Points.change_point(point)
  end
end
