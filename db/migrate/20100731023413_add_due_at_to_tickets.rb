class AddDueAtToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :due_at, :datetime
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
