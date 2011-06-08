class AddSearchStringToCollections < ActiveRecord::Migration
  def self.up
    add_column :collections, :search_string, :string
  end

  def self.down
    remove_column :collections, :search_string
  end
end
