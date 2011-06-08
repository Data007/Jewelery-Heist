class CreateDesigners < ActiveRecord::Migration
  def self.up
    create_table :designers do |t|
      t.integer :user_id, :default => User.find(:first, :conditions => {:name => "Sarah J. Christenson"}).id
      t.string :name

      t.timestamps
    end
    
    add_column :items, :designer_id, :integer
  end

  def self.down
    remove_column :items, :designer_id
    drop_table :designers
  end
end
