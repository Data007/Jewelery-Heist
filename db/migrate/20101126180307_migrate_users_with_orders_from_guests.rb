class MigrateUsersWithOrdersFromGuests < ActiveRecord::Migration
  def self.up
    time_started = Time.now
    puts "- Finding customers from orders who were marked as guests"
    Order.find(:all).each do |order|
      print "Extracting user from order ##{order.id} ... "
      customer = order.user
      if customer
        print "found ##{customer.id} - Migrating ... "
        customer.role_name = "customer" if customer.role_name == "guest"
        if customer.save
          puts "migrated"
        else
          puts "failed"
        end
      else
        puts "no user found"
      end
      time_ended = Time.now
      puts "- Finding customers from orders who were marked as guests ... done - Time Elapsed: #{time_ended - time_started}"
    end
  end

  def self.down
    time_started = Time.now
    puts "- Finding customers from orders who were marked as customers"
    Order.find(:all).each do |order|
      print "Extracting user from order ##{order.id} ... "
      customer = order.user
      if customer
        print "found ##{customer.id} - Migrating ... "
        customer.role_name = "guest" if customer.role_name == "customer"
        if customer.save
          puts "migrated"
        else
          puts "failed"
        end
      else
        puts "no user found"
      end
      time_ended = Time.now
      puts "- Finding customers from orders who were marked as customer ... done - Time Elapsed: #{time_ended - time_started}"
    end
  end
end
