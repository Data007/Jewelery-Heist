class AddAvailabilityToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :available, :boolean, :default => true
    Item.reset_column_information
    Item.find(:all).each {|item| item.update_attributes :available => true }
  end

  def self.down
    remove_column :items, :available
  end
end
