class InitiateRolesForUsers < ActiveRecord::Migration
  def self.up
    [
      {
        :id         => "1",
        :role_name  => "owner"
      },
      {
        :id         => "2",
        :role_name  => "owner"
      },
      {
        :id         => "3",
        :role_name  => "owner"
      },
      {
        :id         => "4",
        :role_name  => "owner"
      },
      {
        :id         => "5",
        :role_name  => "owner"
      },
      {
        :id         => "6",
        :role_name  => "employee"
      },
      {
        :id         => "7",
        :role_name  => "employee"
      },
      {
        :id         => "8",
        :role_name  => "manager"
      },
      {
        :id         => "9",
        :role_name  => "employee"
      },
      {
        :id         => "10",
        :role_name  => "employee"
      }
    ].each do |user|
      begin
        User.find(user[:id]).update_attributes :role_name => user[:role_name]
      rescue; end
    end
  end

  def self.down
    User.find(:all).each do |user|
      user.update_attributes :role_name => "employee"
    end
  end
end
