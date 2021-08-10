defmodule EmployeeRewardApp.RewardTest do
  use EmployeeRewardApp.DataCase

  alias EmployeeRewardApp.Reward

  describe "points" do
    alias EmployeeRewardApp.Reward.Points.Point

    @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", pool: 42, received: 42}
    @update_attrs %{id: "7488a646-e31f-11e4-aace-600308960668", pool: 43, received: 43}
    @invalid_attrs %{id: nil, pool: nil, received: nil}

    def point_fixture(attrs \\ %{}) do
      {:ok, point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reward.create_point()

      point
    end

    test "list_points/0 returns all points" do
      point = point_fixture()
      assert Reward.list_points() == [point]
    end

    test "get_point!/1 returns the point with given id" do
      point = point_fixture()
      assert Reward.get_point!(point.id) == point
    end

    test "create_point/1 with valid data creates a point" do
      assert {:ok, %Point{} = point} = Reward.create_point(@valid_attrs)
      assert point.id == "7488a646-e31f-11e4-aace-600308960662"
      assert point.pool == 42
      assert point.received == 42
    end

    test "create_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reward.create_point(@invalid_attrs)
    end

    test "update_point/2 with valid data updates the point" do
      point = point_fixture()
      assert {:ok, %Point{} = point} = Reward.update_point(point, @update_attrs)
      assert point.id == "7488a646-e31f-11e4-aace-600308960668"
      assert point.pool == 43
      assert point.received == 43
    end

    test "update_point/2 with invalid data returns error changeset" do
      point = point_fixture()
      assert {:error, %Ecto.Changeset{}} = Reward.update_point(point, @invalid_attrs)
      assert point == Reward.get_point!(point.id)
    end

    test "delete_point/1 deletes the point" do
      point = point_fixture()
      assert {:ok, %Point{}} = Reward.delete_point(point)
      assert_raise Ecto.NoResultsError, fn -> Reward.get_point!(point.id) end
    end

    test "change_point/1 returns a point changeset" do
      point = point_fixture()
      assert %Ecto.Changeset{} = Reward.change_point(point)
    end
  end
end
