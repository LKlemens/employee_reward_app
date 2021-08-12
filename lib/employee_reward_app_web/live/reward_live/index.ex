defmodule EmployeeRewardAppWeb.RewardLive.Index do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Reward
  alias EmployeeRewardApp.Accounts

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok,
     socket
     |> assign_user(token)
     |> assign_users()
     |> assign_pool()}
  end

  def assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  def assign_users(socket) do
    assign(socket, :users, Reward.list_users())
  end

  def assign_pool(socket) do
    assign(socket, :pool, get_pool(current_user_id(socket)))
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    user = Reward.get_user(id)

    socket
    |> assign(:page_title, page_title(user.email))
    |> assign(:user, user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rewards")
    |> assign(:user, nil)
  end

  defp page_title(email) do
    "Edit " <> email <> "'s reward"
  end

  defp current_user_id(socket) do
    socket.assigns.current_user.id
  end

  defp get_pool(user_id) do
    Reward.get_user(user_id).point.pool
  end
end
