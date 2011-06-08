class AddMetalsAndStonesToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :metals, :string
    add_column :orders, :stones, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
