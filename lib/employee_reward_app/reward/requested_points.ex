defmodule EmployeeRewardApp.Reward.RequestedPoints do
  import Ecto.Changeset
  alias EmployeeRewardApp.Reward.RequestedPoints.RequestedPoint

  def create_requested_point(attrs \\ %{}) do
    %RequestedPoint{}
    |> RequestedPoint.changeset(attrs)
    |> Ecto.Changeset.apply_action(:validate)
  end

  def change_requested_point(%RequestedPoint{} = requested_point, attrs \\ %{}) do
    RequestedPoint.changeset(requested_point, attrs)
  end
end
