class AddPriceToVariations < ActiveRecord::Migration
  def self.up
    add_column :variations, :price, :decimal, :precision => 6, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :variations, :price
  end
end
