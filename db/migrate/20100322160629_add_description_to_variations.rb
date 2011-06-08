class AddDescriptionToVariations < ActiveRecord::Migration
  def self.up
    add_column :variations, :description, :text
  end

  def self.down
    remove_column :variations, :description
  end
end
