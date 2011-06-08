class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :custom_id, :size_range
      t.text :description
      t.boolean :published, :one_of_a_kind, :default => false
      t.decimal :price, :cost, :precision => 6, :scale => 2, :default => 0.0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
