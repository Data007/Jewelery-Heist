class RemovePaymentTypesPaymentsJoinTableAndAddPaymentTypeIdToPayments < ActiveRecord::Migration
  def self.up
    drop_table :payment_types_payments
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
