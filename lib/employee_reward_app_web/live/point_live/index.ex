defmodule EmployeeRewardAppWeb.PointLive.Index do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Reward
  alias EmployeeRewardApp.Reward.Points.Point

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :points, list_points())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Point")
    |> assign(:point, Reward.get_point!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Point")
    |> assign(:point, %Point{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Points")
    |> assign(:point, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    point = Reward.get_point!(id)
    {:ok, _} = Reward.delete_point(point)

    {:noreply, assign(socket, :points, list_points())}
  end

  defp list_points do
    Reward.list_points()
  end
end
