class AddCurrentStageNotesToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :current_stage_notes, :text
  end

  def self.down
    remove_column :tickets, :current_stage_notes
  end
end
