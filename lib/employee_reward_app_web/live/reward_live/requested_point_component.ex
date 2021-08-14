defmodule EmployeeRewardAppWeb.RewardLive.RequestedPointComponent do
  use EmployeeRewardAppWeb, :live_component

  alias EmployeeRewardApp.Reward
  alias EmployeeRewardApp.Reward.RequestedPoints.RequestedPoint

  @impl true
  def update(%{pool: pool, from: from, id: to} = assigns, socket) do
    requested_point = Reward.create_default_requested_point(pool)
    changeset = Reward.change_requested_point(requested_point)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:from, from)
     |> assign(:to, to)
     |> assign(:requested_point, requested_point)}
  end

  @impl true
  def handle_event("validate", %{"requested_point" => requested_point_params} = heh, socket) do
    IO.inspect(heh, label: "dsaf")

    changeset =
      socket.assigns.requested_point
      |> Reward.change_requested_point(requested_point_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"requested_point" => requested_point_params}, socket) do
    save_user(socket, socket.assigns.action, requested_point_params)
  end

  defp save_user(socket, :update, requested_point_params) do
    params =
      requested_point_params
      |> Map.put("from", socket.assigns.from)
      |> Map.put("to", socket.assigns.to)

    case Reward.commit_reward(params) do
      {:ok, _requeested_point} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reward send successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, _failed_operation, %Ecto.Changeset{} = changeset, _changes} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Something goes wrong when commit reward. Please concat with administrator."
         )
         |> push_redirect(to: socket.assigns.return_to)}
    end
  end
end
