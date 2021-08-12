defmodule EmployeeRewardApp.Accounts.User.Query do
  import Ecto
  import Ecto.Query

  alias EmployeeRewardApp.Accounts.User
  def base, do: User

  def all_users_with_point do
    from(u in base(),
      join: p in assoc(u, :point),
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
end
