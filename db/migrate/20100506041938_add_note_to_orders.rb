class AddNoteToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :notes, :text
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
