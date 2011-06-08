# A Sample User
# --
# Name: Required
# Nickname: Optional
# Email: Required
# Password: Required
# IsActive: Required
# Phone: Optional
# PhotoUrl: Optional
# Bio: Optional

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :name, :nickname
      t.text :password, :bio, :photo_url
      t.integer :phone
      t.boolean :is_active, :is_administrator, :is_manager, :is_employee, :is_customer, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
