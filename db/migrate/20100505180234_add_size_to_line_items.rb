class AddSizeToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :size, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
