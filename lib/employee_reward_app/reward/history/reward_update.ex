defmodule EmployeeRewardApp.Reward.History.RewardUpdate do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmployeeRewardApp.Accounts

  @foreign_key_type :binary_id
  schema "reward_updates" do
    field(:operation, Ecto.Enum, values: [:update, :undo])
    field(:points, :integer)
    field(:from, :binary_id)
    field(:to, :binary_id)
    belongs_to(:donor, Accounts.User, foreign_key: :from, define_field: false)

    timestamps()
  end

  @doc false
  def changeset(reward_update, attrs) do
    reward_update
    |> cast(attrs, [:operation, :points, :from, :to])
    |> validate_required([:operation, :points, :from, :to])
  end
end
