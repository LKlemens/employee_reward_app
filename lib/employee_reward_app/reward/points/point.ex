defmodule EmployeeRewardApp.Reward.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmployeeRewardApp.Accounts

  @foreign_key_type :binary_id
  schema "points" do
    field :pool, :integer,
      default: Application.get_env(:employee_reward_app, :start_points_pool, 50)

    field :received, :integer, default: 0
    belongs_to(:user, Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:pool, :received, :user_id])
    |> validate_required([:pool, :received, :user_id])
    |> unique_constraint(:user_id)
  end
end
