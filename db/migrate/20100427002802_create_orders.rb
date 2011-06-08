class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :user_id
      t.integer :ticket_id
      t.boolean :ghost
      t.text :shipping_address
      t.text :emails
      t.text :phones

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
