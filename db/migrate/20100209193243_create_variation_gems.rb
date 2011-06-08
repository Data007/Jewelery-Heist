class CreateVariationGems < ActiveRecord::Migration
  def self.up
    create_table :variation_gems do |t|
      t.string :name
      t.integer :variation_id
    end
  end

  def self.down
    drop_table :variation_gems
  end
end
