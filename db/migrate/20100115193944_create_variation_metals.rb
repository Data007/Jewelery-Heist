class CreateVariationMetals < ActiveRecord::Migration
  def self.up
    create_table :variation_metals do |t|
      t.string :metal
      t.integer :variation_id
    end
  end

  def self.down
    drop_table :variation_metals
  end
end
