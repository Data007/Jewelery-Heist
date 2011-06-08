class AddPriceToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
