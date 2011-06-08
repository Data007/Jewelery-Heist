class RemovePriceFromItems < ActiveRecord::Migration
  def self.up
    remove_column :items, :price
  end

  def self.down
    t.decimal :price, :cost, :precision => 6, :scale => 2, :default => 0.0
  end
end
