class AddShowWaxToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :show_wax, :boolean, :default => true
  end

  def self.down
    remove_column :orders, :show_wax
  end
end
