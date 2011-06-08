class AddRefundedToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :refunded, :boolean, :default => false
  end

  def self.down
    remove_column :line_items, :refunded
  end
end
