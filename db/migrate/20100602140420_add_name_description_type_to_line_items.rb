class AddNameDescriptionTypeToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :is_quick_item, :boolean, :default => false
    add_column :line_items, :name, :string
    add_column :line_items, :description, :text
  end

  def self.down
    remove_column :line_items, :is_quick_item
    remove_column :line_items, :name
    remove_column :line_items, :description
  end
end
