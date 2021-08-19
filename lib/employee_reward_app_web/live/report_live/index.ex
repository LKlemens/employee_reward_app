defmodule EmployeeRewardAppWeb.ReportLive.Index do
  use EmployeeRewardAppWeb, :live_view

  alias EmployeeRewardApp.Accounts
  alias EmployeeRewardApp.Reward
  alias EmployeeRewardApp.TimeManipulation

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok,
     socket
     |> assign_current_user(token)
     |> assign_date()
     |> assign_reports()
     |> assign_point()}
  end

  @impl true
  def handle_params(%{"move" => action}, _path, socket) do
    {:noreply,
     socket
     |> assign(:date, TimeManipulation.update_date(action, socket.assigns.date))
     |> assign_reports()
     |> push_patch(to: "/rewards/reports")}
  end

  @impl true
  def handle_params(_params, _path, socket) do
    {:noreply, socket}
  end

  def assign_current_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  def assign_reports(socket) do
    assign(socket, :reports, Accounts.get_user_with_sum_of_rewards_for_month(socket.assigns.date))
  end

  def assign_point(socket) do
    assign(socket, :point, get_point(current_user_id(socket)))
  end

  defp assign_date(socket) do
    assign(socket, :date, TimeManipulation.now())
  end

  defp current_user_id(socket) do
    socket.assigns.current_user.id
  end

  defp get_point(user_id) do
    Reward.get_user(user_id).point
  end

  defp format_date(date) do
    TimeManipulation.format_date(date)
  end

  def svg_arrow(points) do
    """
      <svg xmlns="http://www.w3.org/2000/svg" version="1.1" class="svg-triangle" width='100' height='100'>
        <polygon points="#{points}"/>
      </svg>
    """
  end
end
