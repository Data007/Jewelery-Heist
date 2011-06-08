class AddInstoreCreditToPaymentTypes < ActiveRecord::Migration
  def self.up
    PaymentType.create(:name => "In Store Credit") unless PaymentType.find_by_name("In Store Credit")
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
