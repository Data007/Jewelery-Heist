class ReenstateAddressColumnsInOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :address_1
    remove_column :orders, :address_2
    remove_column :orders, :city
    remove_column :orders, :province
    remove_column :orders, :postal_code
    remove_column :orders, :country
    
    Order.reset_column_information
    
    add_column :orders, :address_1, :string
    add_column :orders, :address_2, :string
    add_column :orders, :city, :string
    add_column :orders, :province, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :country, :string, :default => "US"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
