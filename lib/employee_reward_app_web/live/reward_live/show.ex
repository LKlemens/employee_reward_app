defmodule EmployeeRewardAppWeb.RewardLive.Show do
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

    {:ok, socket}
  end

  def assign_current_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user = get_user(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:page_title, page_title(socket.assigns.live_action, user.email))
     |> assign_return_to(user)}
  end

  def assign_return_to(socket, user) do
    assign(socket, :return_to, Routes.reward_show_path(socket, :show, socket.assigns.user))
  end

  @impl true
  def handle_event("undo", %{"reward-id" => reward_id}, socket) do
    case Reward.undo_reward_update!(reward_id) do
      {:ok, changeset} ->
        broadcast(changeset.to.user_id)

        {:noreply,
         assign(socket, :user, get_user(socket.assigns.user.id))
         |> notification(:undo, "Successfully undo the reward")}

      {:error, _} ->
        undo_error(socket)
    end
  rescue
    _ ->
      undo_error(socket)
  end

  def handle_info(%{event: "update_points", payload: %{msg: msg}}, socket) do
    user = get_user(socket.assigns.current_user.id)

    {:noreply,
     assign(socket, :user, user)
     |> notification(socket.assigns.live_action, msg)}
  end

  defp notification(socket, :edit, _msg) do
    socket
  end

  defp notification(socket, _action, msg) do
    socket
    |> put_flash(:info, msg)
    |> redirect(to: "/rewards/" <> socket.assigns.current_user.id)
  end

  defp get_user(id) do
    Reward.get_user_with_rewards(id) || Reward.get_user(id)
  end

  defp undo_error(socket) do
    {:noreply,
     socket
     |> put_flash(
       :error,
       "Something goes wrong when undo reward. Please contact with administrator."
     )
     |> push_redirect(to: socket.assigns.return_to)}
  end

  defp broadcast(user_id) do
    Endpoint.broadcast(
      @received_points_topic <> user_id,
      "update_points",
      %{msg: "Your reward has been withdrawn :("}
    )
  end

  defp page_title(:show, email), do: email <> " Rewards Summary"
  defp page_title(:edit, email), do: "Edit " <> email <> "'s Rewards"
end
