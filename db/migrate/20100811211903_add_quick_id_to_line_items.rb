class AddQuickIdToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :quick_id, :string, :default => "na"
  end

  def self.down
    remove_column :line_items, :quick_id
  end
end
