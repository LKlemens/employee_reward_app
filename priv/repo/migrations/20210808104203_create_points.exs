defmodule EmployeeRewardApp.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add(:pool, :integer, null: false)
      add(:received, :integer, null: false)
      add(:user_id, references(:users, type: :binary_id, on_delete: :nothing), null: false)

      timestamps()
    end

    create(unique_index(:points, [:user_id]))
  end
end
