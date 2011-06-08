class StripSpacesFromCreditCardNames < ActiveRecord::Migration
  def self.up
    PaymentType.find(:all).each {|p| p.update_attributes :name => p.name.gsub(" ", "")}
  end

  def self.down
    raise ActiveRecord::IrreveresibleMigration
  end
end
