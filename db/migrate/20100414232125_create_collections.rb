class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
    
    create_table :collections_items, :id => false do |t|
      t.integer :collection_id, :item_id
    end
  end

  def self.down
    drop_table :collections_items
    drop_table :collections
  end
end
