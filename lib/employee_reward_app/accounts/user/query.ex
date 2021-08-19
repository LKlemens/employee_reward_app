defmodule EmployeeRewardApp.Accounts.User.Query do
  use EmployeeRewardApp.Query

  alias EmployeeRewardApp.Accounts.User
  alias EmployeeRewardApp.Reward.History.RewardUpdate

  def base, do: User

  def all_users_with_point do
    from(u in base(),
      join: p in assoc(u, :point),
      order_by: [desc: u.email],
      preload: [point: p]
    )
  end

  def with_point(user_id) do
    from(u in base(),
      join: p in assoc(u, :point),
      where: u.id == ^user_id,
      preload: [point: p]
    )
  end

  def with_rewards(user_id, date) do
    from(u in base(),
      join: r in assoc(u, :reward_updates),
      join: p in assoc(u, :point),
      where: u.id == ^user_id,
      where: date_part("month", r.inserted_at) == ^date.month,
      where: date_part("year", r.inserted_at) == ^date.year,
      order_by: [desc: r.inserted_at],
      preload: [reward_updates: {r, :endowed}, point: p]
    )
  end

  def with_sum_rewards_for_month(date) do
    from(
      q in subquery(user_join_with_sum_of_rewards(date)),
      select: %{email: q.email, sum_points: coalesce(q.sum_points, 0)}
    )
  end

  defp sum_of_rewards_per_month(date) do
    from(r in RewardUpdate,
      where: date_part("month", r.inserted_at) == ^date.month,
      where: date_part("year", r.inserted_at) == ^date.year,
      group_by: r.to,
      select: %{to: r.to, sum_points: sum(r.points)}
    )
  end

  defp user_join_with_sum_of_rewards(date) do
    from(u in base(),
      left_lateral_join: sq in subquery(sum_of_rewards_per_month(date)),
      on: sq.to == u.id,
      order_by: u.email,
      select: %{email: u.email, id: u.id, sum_points: sq.sum_points}
    )
  end
end
