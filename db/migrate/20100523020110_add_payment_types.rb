class AddPaymentTypes < ActiveRecord::Migration
  def self.up
    ["Master Card", "Visa", "American Express", "Discover", "Cash", "Check"].each do |t|
      PaymentType.create!(:name => t)
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
