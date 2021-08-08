defmodule EmployeeRewardApp.Reward.PointsTest do
  use EmployeeRewardApp.DataCase

  alias EmployeeRewardApp.Reward.Points

  describe "points" do
    alias EmployeeRewardApp.Reward.Points.Point

    @valid_attrs %{pool: 42, received: 42}
    @update_attrs %{pool: 43, received: 43}
    @invalid_attrs %{pool: nil, received: nil}

    def point_fixture(attrs \\ %{}) do
      {:ok, point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Points.create_point()

      point
    end

    test "list_points/0 returns all points" do
      point = point_fixture()
      assert Points.list_points() == [point]
    end

    test "get_point!/1 returns the point with given id" do
      point = point_fixture()
      assert Points.get_point!(point.id) == point
    end

    test "create_point/1 with valid data creates a point" do
      assert {:ok, %Point{} = point} = Points.create_point(@valid_attrs)
      assert point.pool == 42
      assert point.received == 42
    end

    test "create_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Points.create_point(@invalid_attrs)
    end

    test "update_point/2 with valid data updates the point" do
      point = point_fixture()
      assert {:ok, %Point{} = point} = Points.update_point(point, @update_attrs)
      assert point.pool == 43
      assert point.received == 43
    end

    test "update_point/2 with invalid data returns error changeset" do
      point = point_fixture()
      assert {:error, %Ecto.Changeset{}} = Points.update_point(point, @invalid_attrs)
      assert point == Points.get_point!(point.id)
    end

    test "delete_point/1 deletes the point" do
      point = point_fixture()
      assert {:ok, %Point{}} = Points.delete_point(point)
      assert_raise Ecto.NoResultsError, fn -> Points.get_point!(point.id) end
    end

    test "change_point/1 returns a point changeset" do
      point = point_fixture()
      assert %Ecto.Changeset{} = Points.change_point(point)
    end
  end
end
