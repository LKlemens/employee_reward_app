defmodule EmployeeRewardApp.Reward.History.RewardUpdate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reward_updates" do
    field(:operation, Ecto.Enum, values: [:update, :undo])
    field(:points, :integer)
    field(:from, :binary_id)
    field(:to, :binary_id)

    timestamps()
  end

  @doc false
  def changeset(reward_update, attrs) do
    reward_update
    |> cast(attrs, [:operation, :points, :from, :to])
    |> validate_required([:operation, :points, :from, :to])
  end
end
