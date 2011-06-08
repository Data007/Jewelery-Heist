class ChangePricePrecisionTo10OnVariations < ActiveRecord::Migration
  def self.up
    change_column :variations, :price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
