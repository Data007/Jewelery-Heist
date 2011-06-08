class AddClerkIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :clerk_id, :integer
  end

  def self.down
    remove_column :orders, :clerk_id
  end
end
