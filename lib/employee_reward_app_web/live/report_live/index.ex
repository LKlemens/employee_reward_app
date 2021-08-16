defmodule EmployeeRewardAppWeb.ReportLive.Index do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Accounts
  alias EmployeeRewardApp.Reward
  alias EmployeeRewardAppWeb.Endpoint

  @received_points_topic "received_points:"
  @pool_points_topic "pool_points:"

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    socket = assign_current_user(socket, token)

    if connected?(socket) do
      user_id = socket.assigns.current_user.id
      Endpoint.subscribe(@received_points_topic <> user_id)
      Endpoint.subscribe(@pool_points_topic <> user_id)
    end

    {:ok,
     socket
     |> assign_users()
     |> assign_point()}
  end

  def assign_current_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  def assign_users(socket) do
    assign(socket, :users, list_users(socket.assigns.current_user))
  end

  def assign_point(socket) do
    assign(socket, :point, get_point(current_user_id(socket)))
  end

  defp list_users(currenct_user) do
    Reward.list_users()
    |> Enum.reject(&compare_myself(&1, currenct_user))
  end

  defp current_user_id(socket) do
    socket.assigns.current_user.id
  end

  defp get_point(user_id) do
    Reward.get_user(user_id).point
  end

  defp compare_myself(user, currenct_user) do
    user.role == :user && user.id == currenct_user.id
  end
end