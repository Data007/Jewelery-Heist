class AddLocationToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :location, :string, :default => "website"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
