defmodule EmployeeRewardApp.Reward.Points.Point do
  use Ecto.Schema
  import Ecto.Changeset

  schema "points" do
    field :pool, :integer
    field :received, :integer
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(point, attrs) do
    point
    |> cast(attrs, [:pool, :received])
    |> validate_required([:pool, :received])
  end
end
