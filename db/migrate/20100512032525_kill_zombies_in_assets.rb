class KillZombiesInAssets < ActiveRecord::Migration
  def self.up
    Asset.find(:all, :conditions => {:ghost => true}).each do |a|
      puts a.inspect
      a.destroy
    end
    remove_column :assets, :ghost
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
