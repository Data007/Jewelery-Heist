class GhostFalseByDefault < ActiveRecord::Migration
  def self.up
    change_column :orders, :ghost, :boolean, :default => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
