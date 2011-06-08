class CreateGenders < ActiveRecord::Migration
  def self.up
    create_table :genders do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_column :items, :gender_id, :integer
  end

  def self.down
    remove_column :items, :gender_id
    drop_table :genders
  end
end
