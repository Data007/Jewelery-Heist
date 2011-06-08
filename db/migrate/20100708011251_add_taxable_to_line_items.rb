class AddTaxableToLineItems < ActiveRecord::Migration
  def self.up
    add_column :line_items, :taxable, :boolean, :default => false
  end

  def self.down
    raise ActiveRecord::IrreversableMigration
  end
end
