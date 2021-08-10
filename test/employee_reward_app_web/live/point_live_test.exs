defmodule EmployeeRewardAppWeb.PointLiveTest do
  use EmployeeRewardAppWeb.ConnCase

  import Phoenix.LiveViewTest

  alias EmployeeRewardApp.Reward

  @create_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", pool: 42, received: 42}
  @update_attrs %{id: "7488a646-e31f-11e4-aace-600308960668", pool: 43, received: 43}
  @invalid_attrs %{id: nil, pool: nil, received: nil}

  defp fixture(:point) do
    {:ok, point} = Reward.create_point(@create_attrs)
    point
  end

  defp create_point(_) do
    point = fixture(:point)
    %{point: point}
  end

  describe "Index" do
    setup [:create_point]

    test "lists all points", %{conn: conn, point: point} do
      {:ok, _index_live, html} = live(conn, Routes.point_index_path(conn, :index))

      assert html =~ "Listing Points"
    end

    test "saves new point", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.point_index_path(conn, :index))

      assert index_live |> element("a", "New Point") |> render_click() =~
               "New Point"

      assert_patch(index_live, Routes.point_index_path(conn, :new))

      assert index_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#point-form", point: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.point_index_path(conn, :index))

      assert html =~ "Point created successfully"
    end

    test "updates point in listing", %{conn: conn, point: point} do
      {:ok, index_live, _html} = live(conn, Routes.point_index_path(conn, :index))

      assert index_live |> element("#point-#{point.id} a", "Edit") |> render_click() =~
               "Edit Point"

      assert_patch(index_live, Routes.point_index_path(conn, :edit, point))

      assert index_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#point-form", point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.point_index_path(conn, :index))

      assert html =~ "Point updated successfully"
    end

    test "deletes point in listing", %{conn: conn, point: point} do
      {:ok, index_live, _html} = live(conn, Routes.point_index_path(conn, :index))

      assert index_live |> element("#point-#{point.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#point-#{point.id}")
    end
  end

  describe "Show" do
    setup [:create_point]

    test "displays point", %{conn: conn, point: point} do
      {:ok, _show_live, html} = live(conn, Routes.point_show_path(conn, :show, point))

      assert html =~ "Show Point"
    end

    test "updates point within modal", %{conn: conn, point: point} do
      {:ok, show_live, _html} = live(conn, Routes.point_show_path(conn, :show, point))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Point"

      assert_patch(show_live, Routes.point_show_path(conn, :edit, point))

      assert show_live
             |> form("#point-form", point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#point-form", point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.point_show_path(conn, :show, point))

      assert html =~ "Point updated successfully"
    end
  end
end
