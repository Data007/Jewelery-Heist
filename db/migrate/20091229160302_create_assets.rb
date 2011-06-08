class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :image_file_name, :image_content_type
      t.integer :users, :image_file_size
      t.datetime :users, :image_updated_at
      
      t.references :attachable, :polymorphic => true
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
