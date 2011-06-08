class AddPurchasedAtAndCompletedAtToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :purchased_at, :datetime
    add_column :orders, :completed_at, :datetime
    
    Order.reset_column_information
    
    Order.find(:all).each do |order|
      print "-- SETTING :purchased_at IN GENERAL FOR ORDER ##{order.id} ... "
      order.update_attributes :purchased_at => order.created_at
      puts "DONE"
    end
    
    Order.registered.each do |order|
      if order.payments.length > 0
        print "-- SETTING :purchased_at USING REGISTERED ORDERS FOR ORDER ##{order.id} ... "
        order.update_attributes :purchased_at => order.payments.first.created_at
        puts "DONE"
      end
    end
    
    Order.handed_off.each do |order|
      print "-- SETTING :purchased_at AND :completed_at USING COMPLETED ORDERS FOR ORDER ##{order.id} ... "
      dated = order.payments.length > 0 ? order.payments.last.created_at : order.updated_at
      order.update_attributes :purchased_at => dated, :completed_at => dated
      order.ticket.last_stage
      order.ticket.save
      puts "DONE"
    end
  end

  def self.down
    remove_column :orders, :purchased_at
    remove_column :orders, :completed_at
  end
end
