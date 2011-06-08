class RemoveCategoriesItemsAndAddCategoryIdToItems < ActiveRecord::Migration
  def self.up
    drop_table :categories_items
    add_column :items, :category_id, :integer
  end

  def self.down
    raise "ActiveRecord::IrreversibleMigration"
  end
end
