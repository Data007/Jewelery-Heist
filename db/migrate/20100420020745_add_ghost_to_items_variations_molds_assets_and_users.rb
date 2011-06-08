class AddGhostToItemsVariationsMoldsAssetsAndUsers < ActiveRecord::Migration
  def self.up
    %w(items variations molds assets users collections).each do |t|
      add_column :"#{t}", :ghost, :boolean, :default => false
    end
  end

  def self.down
    %w(items variations molds assets users collections).each do |t|
      remove_column :"#{t}", :ghost
    end
  end
end
