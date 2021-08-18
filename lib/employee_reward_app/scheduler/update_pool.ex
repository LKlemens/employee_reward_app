defmodule EmployeeRewardApp.Scheduler.UpdatePool do
  alias EmployeeRewardApp.Reward

  @pool_value Application.get_env(:employee_reward_app, :start_points_pool, 50)

  def update_pool_for_all() do
    Reward.update_all_points(@pool_value)
  end
end
