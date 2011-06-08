class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :order_id
      t.integer :payment_type_id
      t.string :check_number

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
