defmodule EmployeeRewardApp.Reward do
  @moduledoc """
  The Reward context.
  """

  import Ecto.Query, warn: false
  alias EmployeeRewardApp.Repo

  alias EmployeeRewardApp.Accounts
  alias EmployeeRewardApp.Reward.History
  alias EmployeeRewardApp.Reward.Points
  alias EmployeeRewardApp.Reward.Points.Point
  alias EmployeeRewardApp.Reward.RequestedPoints
  alias EmployeeRewardApp.Reward.RequestedPoints.RequestedPoint

  def undo_reward_update!(id) do
    reward = History.get_reward_update!(id)
    point_from = Repo.get_by(Point, user_id: reward.from)
    point_to = Repo.get_by(Point, user_id: reward.to)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:to, decreate_points(point_to, reward.points, :reverse))
    |> Ecto.Multi.update(:from, add_points(point_from, reward.points, :reverse))
    |> Ecto.Multi.update(
      :reward_update,
      History.change_reward_update(reward, %{operation: :undo})
    )
    |> Ecto.Multi.run(:reward_insert_reverse, fn _repo, _changes ->
      undo_history(reward)
    end)
    |> Repo.transaction()
  end

  defp undo_history(reward) do
    History.create_reward_update(%{
      operation: :undo,
      points: reverse_number_sign(reward.points),
      from: reward.from,
      to: reward.to
    })
  end

  defp reverse_number_sign(points), do: points * -1

  def get_user_with_rewards(id) do
    Accounts.get_user_with_rewards(id)
  end

  @doc """
  Creates a requested_point.

  ## Examples

      iex> create_requested_point(%{field: value})
      {:ok, %RequestedPoint{}}

      iex> create_requested_point(%{field: bad_value})
      {:error, ...}

  """
  def create_requested_point(attrs \\ %{}) do
    RequestedPoints.create_requested_point(attrs)
  end

  def create_default_requested_point(pool) do
    %RequestedPoint{pool: pool, points: 0}
  end

  def change_requested_point(%RequestedPoint{} = requested_point, attrs \\ %{}) do
    RequestedPoints.change_requested_point(requested_point, attrs)
  end

  def commit_reward(attrs \\ %{}) do
    points = get_points(attrs)
    point_from = Repo.get_by(Point, user_id: attrs["from"])

    point_to =
      Repo.get_by(Point, user_id: attrs["to"])
      |> Repo.preload(:user)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:to, add_points(point_to, points))
    |> Ecto.Multi.update(:from, decreate_points(point_from, points))
    |> Ecto.Multi.run(:history, fn _repo, changes ->
      update_history(points, changes)
    end)
    |> Ecto.Multi.run(:email, fn _repo, _changes ->
      Accounts.send_notification(point_to.user, points)
    end)
    |> Repo.transaction()
  end

  defp update_history(points, changes) do
    History.create_reward_update(%{
      operation: :update,
      points: points,
      to: changes.to.user_id,
      from: changes.from.user_id
    })
  end

  defp get_points(attrs) do
    {points, _} = Integer.parse(attrs["points"])
    points
  end

  defp decreate_points(point_from, points) do
    Points.change_point(point_from, %{pool: point_from.pool - points})
  end

  defp add_points(point_to, points) do
    Points.change_point(point_to, %{received: point_to.received + points})
  end

  defp decreate_points(point_to, points, :reverse) do
    Points.change_point(point_to, %{received: point_to.received - points})
  end

  defp add_points(point_from, points, :reverse) do
    Points.change_point(point_from, %{pool: point_from.pool + points})
  end

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

      iex> get_user(123)
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
  def create_point(_attrs \\ %{}) do
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
  def update_point(%Point{} = point, %{"pool" => _pool} = params) do
    Repo.get_by(Point, user_id: point.user_id)
    |> Point.changeset(params)
    |> Repo.update()
  end

  def update_all_points(pool_value) do
    Repo.update_all(Point, set: [pool: pool_value])
  end

  @doc """
  Deletes a Point.

  ## Examples

      iex> delete_point(point)
      {:ok, %Point{}}

      iex> delete_point(point)
      {:error, ...}

  """
  def delete_point(%Point{} = _point) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking point changes.

  ## Examples

      iex> change_point(point)
      %Todo{...}

  """
  def change_point(%Point{} = point, attrs \\ %{}) do
    Points.change_point(point, attrs)
  end
end
