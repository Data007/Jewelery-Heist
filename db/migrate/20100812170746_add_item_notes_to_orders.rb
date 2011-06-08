class AddItemNotesToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :item_notes, :text
  end

  def self.down
    remove_column :orders, :item_notes
  end
end
