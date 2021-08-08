defmodule EmployeeRewardApp.Reward.HistoryTest do
  use EmployeeRewardApp.DataCase

  alias EmployeeRewardApp.Reward.History

  describe "reward_updates" do
    alias EmployeeRewardApp.Reward.History.RewardUpdate

    @valid_attrs %{operation: "some operation", points: 42}
    @update_attrs %{operation: "some updated operation", points: 43}
    @invalid_attrs %{operation: nil, points: nil}

    def reward_update_fixture(attrs \\ %{}) do
      {:ok, reward_update} =
        attrs
        |> Enum.into(@valid_attrs)
        |> History.create_reward_update()

      reward_update
    end

    test "list_reward_updates/0 returns all reward_updates" do
      reward_update = reward_update_fixture()
      assert History.list_reward_updates() == [reward_update]
    end

    test "get_reward_update!/1 returns the reward_update with given id" do
      reward_update = reward_update_fixture()
      assert History.get_reward_update!(reward_update.id) == reward_update
    end

    test "create_reward_update/1 with valid data creates a reward_update" do
      assert {:ok, %RewardUpdate{} = reward_update} = History.create_reward_update(@valid_attrs)
      assert reward_update.operation == "some operation"
      assert reward_update.points == 42
    end

    test "create_reward_update/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = History.create_reward_update(@invalid_attrs)
    end

    test "update_reward_update/2 with valid data updates the reward_update" do
      reward_update = reward_update_fixture()
      assert {:ok, %RewardUpdate{} = reward_update} = History.update_reward_update(reward_update, @update_attrs)
      assert reward_update.operation == "some updated operation"
      assert reward_update.points == 43
    end

    test "update_reward_update/2 with invalid data returns error changeset" do
      reward_update = reward_update_fixture()
      assert {:error, %Ecto.Changeset{}} = History.update_reward_update(reward_update, @invalid_attrs)
      assert reward_update == History.get_reward_update!(reward_update.id)
    end

    test "delete_reward_update/1 deletes the reward_update" do
      reward_update = reward_update_fixture()
      assert {:ok, %RewardUpdate{}} = History.delete_reward_update(reward_update)
      assert_raise Ecto.NoResultsError, fn -> History.get_reward_update!(reward_update.id) end
    end

    test "change_reward_update/1 returns a reward_update changeset" do
      reward_update = reward_update_fixture()
      assert %Ecto.Changeset{} = History.change_reward_update(reward_update)
    end
  end
end
