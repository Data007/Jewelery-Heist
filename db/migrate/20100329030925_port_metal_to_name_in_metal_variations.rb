class PortMetalToNameInMetalVariations < ActiveRecord::Migration
  def self.up
    add_column :variation_metals, :name, :string
    VariationMetal.reset_column_information
    VariationMetal.find(:all).each {|m| m.update_attributes :name => m.metal}
    remove_column :variation_metals, :metal
  end

  def self.down
    add_column :variation_metals, :metal, :string
    VariationMetal.reset_column_information
    VariationMetal.find(:all).each {|m| m.update_attributes :metal => m.name}
    remove_column :variation_metals, :name
  end
end
