class CreateMoldsVariationsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :molds_variations, :id => false do |t|
      t.references :mold, :variation
    end
    add_index :molds_variations, :mold_id
    add_index :molds_variations, :variation_id
  end

  def self.down
    # remove_index :molds_variations, :mold_id
    remove_index :molds_variations, :variation_id
    drop_table :molds_variations
  end
end
