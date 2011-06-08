class AddSlugToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :slug, :string
  end

  def self.down
    remove_column :items, :slug
  end
end
