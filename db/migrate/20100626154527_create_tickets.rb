class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :order_id, :stage_id
      t.timestamps
    end
    
    remove_column :orders, :ticket_id
  end

  def self.down
    raise ActiveRecord::IrreversableMigration
  end
end
