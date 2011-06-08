class AddDueAtToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :due_at, :string, :default => "3 weeks"
  end

  def self.down
    remove_column :orders, :due_at
  end
end
