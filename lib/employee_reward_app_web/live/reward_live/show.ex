defmodule EmployeeRewardAppWeb.RewardLive.Show do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Reward

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    user = Reward.get_user_with_rewards(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:page_title, page_title(socket.assigns.live_action, user.email))}
  end

  defp page_title(:show, email), do: email <> " Rewards Summary"
  defp page_title(:edit, email), do: "Edit " <> email <> "'s Rewards"
end
