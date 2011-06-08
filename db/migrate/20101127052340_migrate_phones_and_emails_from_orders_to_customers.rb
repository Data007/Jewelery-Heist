class MigratePhonesAndEmailsFromOrdersToCustomers < ActiveRecord::Migration
  def self.up
    Order.find(:all).each do |order|
      print "Extracting email and phone from order ##{order.id} ... "
      customer = order.user
      if customer
        customer.phones.build(:number => customer.phone) if customer.phone && !customer.phones.exists?(:number => customer.phone)
        customer.emails.build(:address => customer.email) if customer.email && !customer.emails.exists?(:address => customer.email)
        customer.save
        puts "created"
      else
        puts "no user found"
      end
    end
  end

  def self.down
    Phone.destroy_all
    Email.destroy_all
  end
end
