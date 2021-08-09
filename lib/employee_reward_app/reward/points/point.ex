defmodule EmployeeRewardApp.Reward.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  alias EmployeeRewardApp.Accounts

  @foreign_key_type :binary_id
  schema "points" do
    field :pool, :integer
    field :received, :integer
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
