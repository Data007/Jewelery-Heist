class CopyAddressesFromOrdersToUsers < ActiveRecord::Migration
  def self.up
    Order.find(:all).each do |order|
      print "Extracting address from order ##{order.id} ... "
      customer = order.user
      if customer
        address = Address.new(:address_1    => order.address_1,
                              :address_2    => order.address_2,
                              :city         => order.city,
                              :province     => order.province,
                              :postal_code  => order.postal_code,
                              :country      => order.country)
        customer.addresses << address unless customer.addresses.exists?(address)
        customer.save
        puts "created"
      else
        puts "no user found"
      end
    end
  end

  def self.down
    Address.destroy_all
  end
end
