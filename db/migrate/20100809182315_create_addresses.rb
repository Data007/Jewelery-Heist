class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.integer :user_id
      t.string :address_1, :address_2, :city, :province, :postal_code, :country
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
