defmodule EmployeeRewardApp.Repo.Migrations.CreateRewardUpdates do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE reward_operation AS ENUM ('update', 'undo')"
    drop_query = "DROP TYPE reward_operation"
    execute(create_query, drop_query)

    create table(:reward_updates) do
      add(:operation, :reward_operation, null: false)
      add(:points, :integer, null: false)
      add(:from, references(:users, type: :binary_id, on_delete: :nothing), null: false)
      add(:to, references(:users, type: :binary_id, on_delete: :nothing), null: false)

      timestamps()
    end

    create(index(:reward_updates, [:from]))
    create(index(:reward_updates, [:to]))
  end
end
