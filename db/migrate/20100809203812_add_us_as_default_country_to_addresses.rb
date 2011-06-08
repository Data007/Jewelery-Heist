class AddUsAsDefaultCountryToAddresses < ActiveRecord::Migration
  def self.up
    change_column :addresses, :country, :string, :default => "US"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
