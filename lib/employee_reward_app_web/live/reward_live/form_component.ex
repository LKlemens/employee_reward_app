defmodule EmployeeRewardAppWeb.RewardLive.FormComponent do
  use EmployeeRewardAppWeb, :live_component

  alias EmployeeRewardApp.Reward
  alias EmployeeRewardAppWeb.Endpoint

  @pool_points_topic "pool_points"

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Reward.change_point(user.point)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"point" => point_params}, socket) do
    changeset =
      socket.assigns.user.point
      |> Reward.change_point(point_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"point" => point_params}, socket) do
    save_user(socket, socket.assigns.action, point_params)
  end

  defp save_user(socket, :edit, point_params) do
    case Reward.update_point(socket.assigns.user.point, point_params) do
      {:ok, _user} ->
        Endpoint.broadcast(@pool_points_topic, "update_points", %{
          msg: "Your pool is updated!"
        })

        {:noreply,
         socket
         |> put_flash(:info, "Pool updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
