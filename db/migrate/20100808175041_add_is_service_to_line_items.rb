class AddIsServiceToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :is_service, :boolean, :default => false
    LineItem.reset_column_information
    LineItem.find(:all).each do |li|
      li.update_attributes :is_service => false
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
