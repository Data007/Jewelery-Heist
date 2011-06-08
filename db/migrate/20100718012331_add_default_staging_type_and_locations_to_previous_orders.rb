class AddDefaultStagingTypeAndLocationsToPreviousOrders < ActiveRecord::Migration
  def self.up
    system "rake orders:clear:old RAILS_ENV=#{RAILS_ENV}"
    
    Order.find(:all).each do |order|
      attributes = {:staging_type => "purchase"}
      attributes[:clerk_id] = User.find_by_login("m3talsmith").id unless order.clerk_id
      attributes[:location] = "website" unless order.location
      
      puts "-- Updating Order ##{order.id} with the following attributes => #{attributes.inspect}"
      
      order.update_attributes attributes
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
