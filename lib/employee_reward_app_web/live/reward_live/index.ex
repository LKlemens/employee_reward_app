defmodule EmployeeRewardAppWeb.RewardLive.Index do
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
      Endpoint.subscribe(@pool_points_topic)
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

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_info(%{event: "update_points", payload: %{msg: msg}}, socket) do
    point = get_point(current_user_id(socket))

    {:noreply,
     socket
     |> assign(:point, point)
     |> notification(socket.assigns.live_action, msg)}
  end

  defp notification(socket, :update, _msg) do
    socket
  end

  defp notification(socket, _action, msg) do
    socket
    |> put_flash(:info, msg)
    |> redirect(to: "/rewards")
  end

  defp apply_action(socket, :edit = action, %{"id" => id}) do
    user = Reward.get_user(id)

    socket
    |> assign(:page_title, page_title(action, user.email))
    |> assign(:user, user)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Rewards")
    |> assign(:user, nil)
  end

  defp apply_action(socket, :update = action, %{"id" => id}) do
    user = Reward.get_user(id)

    socket
    |> assign(:page_title, page_title(action, user.email))
    |> assign(:user, user)
  end

  defp page_title(:edit = action, email) do
    action_to_string(action) <> email <> "'s reward"
  end

  defp page_title(:update, email) do
    "Send reward to " <> email
  end

  defp action_to_string(action) do
    String.capitalize(Atom.to_string(action)) <> " "
  end

  defp current_user_id(socket) do
    socket.assigns.current_user.id
  end

  defp get_point(user_id) do
    Reward.get_user(user_id).point
  end

  defp list_users(currenct_user) do
    Reward.list_users()
    |> Enum.reject(&compare_myself(&1, currenct_user))
  end

  defp compare_myself(user, currenct_user) do
    user.role == :user && user.id == currenct_user.id
  end
end
