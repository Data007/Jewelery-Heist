class AddDescriptionToMolds < ActiveRecord::Migration
  def self.up
    add_column :molds, :description, :text
  end

  def self.down
    remove_column :molds, :description
  end
end
