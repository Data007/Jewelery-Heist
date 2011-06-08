class CreateVariations < ActiveRecord::Migration
  def self.up
    create_table :variations do |t|
      t.integer :quantity, :default => 1
      t.integer :item_id
      t.timestamps
    end
  end

  def self.down
    drop_table :variations
  end
end
