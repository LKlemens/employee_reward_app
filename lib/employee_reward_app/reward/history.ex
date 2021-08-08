defmodule EmployeeRewardApp.Reward.History do
  @moduledoc """
  The Reward.History context.
  """

  import Ecto.Query, warn: false
  alias EmployeeRewardApp.Repo

  alias EmployeeRewardApp.Reward.History.RewardUpdate

  @doc """
  Returns the list of reward_updates.

  ## Examples

      iex> list_reward_updates()
      [%RewardUpdate{}, ...]

  """
  def list_reward_updates do
    Repo.all(RewardUpdate)
  end

  @doc """
  Gets a single reward_update.

  Raises `Ecto.NoResultsError` if the Reward update does not exist.

  ## Examples

      iex> get_reward_update!(123)
      %RewardUpdate{}

      iex> get_reward_update!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reward_update!(id), do: Repo.get!(RewardUpdate, id)

  @doc """
  Creates a reward_update.

  ## Examples

      iex> create_reward_update(%{field: value})
      {:ok, %RewardUpdate{}}

      iex> create_reward_update(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reward_update(attrs \\ %{}) do
    %RewardUpdate{}
    |> RewardUpdate.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reward_update.

  ## Examples

      iex> update_reward_update(reward_update, %{field: new_value})
      {:ok, %RewardUpdate{}}

      iex> update_reward_update(reward_update, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reward_update(%RewardUpdate{} = reward_update, attrs) do
    reward_update
    |> RewardUpdate.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reward_update.

  ## Examples

      iex> delete_reward_update(reward_update)
      {:ok, %RewardUpdate{}}

      iex> delete_reward_update(reward_update)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reward_update(%RewardUpdate{} = reward_update) do
    Repo.delete(reward_update)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reward_update changes.

  ## Examples

      iex> change_reward_update(reward_update)
      %Ecto.Changeset{data: %RewardUpdate{}}

  """
  def change_reward_update(%RewardUpdate{} = reward_update, attrs \\ %{}) do
    RewardUpdate.changeset(reward_update, attrs)
  end
end
