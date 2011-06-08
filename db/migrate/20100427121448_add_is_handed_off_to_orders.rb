class AddIsHandedOffToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :handed_off, :boolean, :default => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
