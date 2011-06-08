class AddClosedAndClosedNoteToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :closed, :boolean, :default => false
    add_column :tickets, :closed_note, :text
  end

  def self.down
    remove_column :tickets, :closed
    remove_column :tickets, :closed_note
  end
end
