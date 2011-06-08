class NormalizeShippingAddressInOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :shipping_address
    add_column :orders, :address_1, :string, :null => false
    add_column :orders, :address_2, :string
    add_column :orders, :city, :string, :null => false
    add_column :orders, :province, :string, :null => false
    add_column :orders, :postal_code, :string, :null => false
    add_column :orders, :country, :string, :default => "US", :null => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
