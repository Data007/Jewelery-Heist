class AddShipToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :ship, :boolean, :default => false
    Order.reset_column_information
    
    Order.find(:all).each do |order|
      print "-- UPDATING ship FOR ORDER ##{order.id} ... "
      order.update_attributes :ship => order.location == "website" ? true : false
      puts "DONE"
    end
  end

  def self.down
    remove_column :orders, :ship
  end
end
