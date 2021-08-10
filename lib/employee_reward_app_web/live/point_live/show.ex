defmodule EmployeeRewardAppWeb.PointLive.Show do
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
     |> assign(:point, Reward.get_point!(id))}
  end

  defp page_title(:show), do: "Show Point"
  defp page_title(:edit), do: "Edit Point"
end
