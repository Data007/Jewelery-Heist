class AddPaypalToPaymentTypes < ActiveRecord::Migration
  def self.up
    PaymentType.create(:name => "Paypal") unless PaymentType.find_by_name("Paypal")
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
