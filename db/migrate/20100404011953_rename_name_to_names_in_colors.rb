class RenameNameToNamesInColors < ActiveRecord::Migration
  def self.up
    rename_column :colors, :name, :names
  end

  def self.down
    rename_column :colors, :names, :name
  end
end
