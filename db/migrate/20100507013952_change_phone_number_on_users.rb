class ChangePhoneNumberOnUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :phone, :string
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
