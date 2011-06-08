class CreateVariationFinishes < ActiveRecord::Migration
  def self.up
    create_table :variation_finishes do |t|
      t.string :name
      t.integer :variation_id
    end
  end

  def self.down
    drop_table :variation_finishes
  end
end
