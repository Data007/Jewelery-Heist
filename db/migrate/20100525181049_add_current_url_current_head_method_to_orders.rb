class AddCurrentUrlCurrentHeadMethodToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :current_url, :string
    add_column :orders, :current_head_method, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
