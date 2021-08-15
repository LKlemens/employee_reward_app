defmodule EmployeeRewardApp.Reward.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmployeeRewardApp.Accounts

  @pool_value Application.get_env(:employee_reward_app, :start_points_pool, 50)

  @foreign_key_type :binary_id
  schema "points" do
    field :pool, :integer, default: @pool_value
    field :received, :integer, default: 0
    belongs_to(:user, Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:pool, :received, :user_id])
    |> validate_required([:pool, :received, :user_id])
    |> validate_number(:pool, greater_than_or_equal_to: 0)
    |> validate_number(:received, greater_than_or_equal_to: 0)
    |> unique_constraint(:user_id)
  end
end
