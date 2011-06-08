class AddCustomizableNotesToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :customizable_notes, :text
  end

  def self.down
    remove_column :items, :customizable_notes
  end
end
