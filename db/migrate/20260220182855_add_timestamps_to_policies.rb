class AddTimestampsToPolicies < ActiveRecord::Migration[7.2]
  def up
    # On older migration was updated to please standardrb regarding timestamps
    # This migration is not needed when building the database from scratch
    unless column_exists?(:policies, :created_at)
      add_timestamps :policies, null: true

      execute "UPDATE policies SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP"

      change_column_null :policies, :created_at, false
      change_column_null :policies, :updated_at, false
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted"
  end
end
