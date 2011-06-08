class AddBackOrderNotesToVariations < ActiveRecord::Migration
  def self.up
    add_column :variations, :backorder_notes, :text
    Variation.reset_column_information
    Variation.find(:all).each {|v| v.update_attributes :backorder_notes => "Please allow 3 - 6 weeks for this order to be created."}
  end

  def self.down
    remove_column :variations, :backorder_notes
  end
end
