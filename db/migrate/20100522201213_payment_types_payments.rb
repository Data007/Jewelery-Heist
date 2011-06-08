class PaymentTypesPayments < ActiveRecord::Migration
  def self.up
    create_table :payment_types_payments, :id => false do |t|
      t.integer :payment_id, :payment_type_id
    end
  end

  def self.down
    drop_table :payment_types_payments
  end
end
