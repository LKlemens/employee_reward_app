defmodule EmployeeRewardAppWeb.RewardLive.Show do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Reward

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Reward.get_user(id))}
  end

  defp page_title(:show), do: "User's Rewards Summary"
  defp page_title(:edit), do: "Edit User's Rewards"
end
