class AddMoldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :molds, :string
  end

  def self.down
    remove_column :orders, :molds
  end
end
