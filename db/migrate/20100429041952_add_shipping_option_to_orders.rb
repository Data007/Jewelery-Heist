class AddShippingOptionToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :shipping_option, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
