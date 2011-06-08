class NormalizeUsersAndRemoveRoleFlags < ActiveRecord::Migration
  def self.up
    rename_column :users, :nickname, :login
    ["is_administrator", "is_manager", "is_employee", "is_customer"].each do |is_role|
      remove_column :users, "#{is_role}"
    end
  end

  def self.down
    rename_column :users, :login, :nickname
    ["is_administrator", "is_manager", "is_employee", "is_customer"].each do |is_role|
      add_column :users, "#{is_role}", :boolean, :default => false
    end
  end
end
