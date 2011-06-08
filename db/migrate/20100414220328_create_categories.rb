class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    
    create_table :categories_items, :id => false do |t|
      t.integer :category_id, :item_id
    end
  end

  def self.down
    drop_table :categories_items
    drop_table :categories
  end
end
