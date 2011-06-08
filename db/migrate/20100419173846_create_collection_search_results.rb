class CreateCollectionSearchResults < ActiveRecord::Migration
  def self.up
    create_table :collection_search_results do |t|
      t.integer :collection_id, :searchable_id
      t.string :searchable_type, :default => "Variation"
      t.timestamps
    end
  end

  def self.down
    drop_table :collection_search_results
  end
end
