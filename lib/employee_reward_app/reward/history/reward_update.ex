defmodule EmployeeRewardApp.Reward.History.RewardUpdate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reward_updates" do
    field :operation, Ecto.Enum, values: [:update, :undo]
    field :points, :integer
    field :from, :id
    field :to, :id

    timestamps()
  end

  @doc false
  def changeset(reward_update, attrs) do
    reward_update
    |> cast(attrs, [:operation, :points])
    |> validate_required([:operation, :points])
  end
end
