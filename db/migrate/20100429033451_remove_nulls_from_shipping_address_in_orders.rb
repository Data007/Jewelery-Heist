class RemoveNullsFromShippingAddressInOrders < ActiveRecord::Migration
  def self.up
    change_column :orders, :address_1, :string
    change_column :orders, :address_2, :string
    change_column :orders, :city, :string
    change_column :orders, :province, :string
    change_column :orders, :postal_code, :string
    change_column :orders, :country, :string, :default => "US"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
