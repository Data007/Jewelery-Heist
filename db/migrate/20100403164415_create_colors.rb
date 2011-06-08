class CreateColors < ActiveRecord::Migration
  def self.up
    create_table :colors do |t|
      t.string :name
      t.integer :position

      t.timestamps
    end
    
    create_table :colors_variations, :id => false do |t|
      t.integer :color_id, :variation_id
    end
    add_index :colors_variations, :color_id
    add_index :colors_variations, :variation_id
  end

  def self.down
    drop_table :colors
    remove_index :colors_variations, :color_id
    remove_index :colors_variations, :variation_id
    drop_table :colors_variations
  end
end
