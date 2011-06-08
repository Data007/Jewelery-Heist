class CreateHeaderImages < ActiveRecord::Migration
  def self.up
    create_table :header_images do |t|
      t.string :title
      t.text :description
      t.boolean :featured
      t.timestamps
    end
  end

  def self.down
    drop_table :header_images
  end
end
