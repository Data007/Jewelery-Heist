class AddPaymentAmountToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :amount, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
