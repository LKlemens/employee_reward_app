defmodule EmployeeRewardAppWeb.PointLive.FormComponent do
  use EmployeeRewardAppWeb, :live_component

  alias EmployeeRewardApp.Reward

  @impl true
  def update(%{point: point} = assigns, socket) do
    changeset = Reward.change_point(point)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"point" => point_params}, socket) do
    changeset =
      socket.assigns.point
      |> Reward.change_point(point_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"point" => point_params}, socket) do
    save_point(socket, socket.assigns.action, point_params)
  end

  defp save_point(socket, :edit, point_params) do
    case Reward.update_point(socket.assigns.point, point_params) do
      {:ok, _point} ->
        {:noreply,
         socket
         |> put_flash(:info, "Point updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_point(socket, :new, point_params) do
    case Reward.create_point(point_params) do
      {:ok, _point} ->
        {:noreply,
         socket
         |> put_flash(:info, "Point created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
