class AddAssignedIdToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :assigned_id, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
