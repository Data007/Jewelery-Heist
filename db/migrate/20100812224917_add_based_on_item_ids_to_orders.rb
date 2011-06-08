class AddBasedOnItemIdsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :based_on_item_ids, :string
  end

  def self.down
    remove_column :orders, :based_on_item_ids
  end
end
