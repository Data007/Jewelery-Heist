class AddKindAndRenameStageIdToCurrentStageIdToTickets < ActiveRecord::Migration
  def self.up
    rename_column :tickets, :stage_id, :current_stage_id
    add_column :tickets, :kind, :string
  end

  def self.down
    raise ActiveRecord::IrreversableMigration
  end
end
