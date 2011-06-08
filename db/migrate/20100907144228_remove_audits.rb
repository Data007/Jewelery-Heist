class RemoveAudits < ActiveRecord::Migration
  def self.up
    drop_table :audits
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
