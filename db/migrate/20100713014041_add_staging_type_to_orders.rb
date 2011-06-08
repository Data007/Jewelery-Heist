class AddStagingTypeToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :staging_type, :string
  end

  def self.down
    remove_column :orders, :staging_type
  end
end
