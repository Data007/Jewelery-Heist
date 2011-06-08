class ForceCurrentTicketsToTheLastStage < ActiveRecord::Migration
  def self.up
    User.create({
      :login => "wexfordadmin",
      :password => "thefamily",
      :role_name => "owner",
      :email => "management@wexfordjewelers.com",
      :name => "Wexford Jewelers"
    })
    
    user = User.find_by_login("wexfordadmin")
    
    Ticket.find(:all).each do |ticket|
      ticket.assigned_id = user unless ticket.assigned_id != nil
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
