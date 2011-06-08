class CreateMolds < ActiveRecord::Migration
  def self.up
    create_table :molds do |t|
      t.string :custom_id
      t.integer :total_injection_count, :current_injection_count
      t.timestamps
    end
  end

  def self.down
    drop_table :molds
  end
end
