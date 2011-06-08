class AddDiscontinuedToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :discontinued, :boolean, :default => false
    add_column :items, :discontinued_notes, :text
  end

  def self.down
    remove_column :items, :discontinued
    remove_column :items, :discontinued_notes
  end
end
