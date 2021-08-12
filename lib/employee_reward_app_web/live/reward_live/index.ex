defmodule EmployeeRewardAppWeb.RewardLive.Index do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Reward

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, Reward.list_users())}
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
end
