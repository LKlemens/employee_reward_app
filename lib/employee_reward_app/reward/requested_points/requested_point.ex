defmodule EmployeeRewardApp.Reward.RequestedPoints.RequestedPoint do
  import Ecto.Changeset

  defstruct ~w/pool points/a
  @types %{pool: :integer, points: :integer}

  def changeset(requested_point, attrs) do
    pool = requested_point.pool || attrs.pool

    {requested_point, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:pool])
    |> validate_number(:points, less_than_or_equal_to: pool)
    |> validate_number(:points, greater_than: 0)
  end
end
