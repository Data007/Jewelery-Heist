class AddRepairNotesToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :repair_notes, :text
  end

  def self.down
    remove_column :orders, :repair_notes
  end
end
