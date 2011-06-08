class TouchAllOrdersToForceTicketCompliance < ActiveRecord::Migration
  def self.up
    # Old orders, introduced before ticketing, do not have tickets.
    # A save will force a ticket on all orders like this
    Order.find(:all).each do |order|
      print "-- Touching order ##{order.id} ... "
      order.save
      puts "DONE"
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
