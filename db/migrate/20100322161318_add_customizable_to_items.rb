class AddCustomizableToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :customizable, :boolean, :default => false
  end

  def self.down
    remove_column :items, :customizable
  end
end
