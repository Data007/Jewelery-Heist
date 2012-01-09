class Admin::InventoryController < ApplicationController
  def index
    @variations = Item.available.map(&:variations)
      .flatten.compact
      .select {|variation| variation if !variation.archived && variation.quantity > 0}
      .flatten.compact
    @quantity_total = @variations.sum(&:quantity)
    @retail_total   = @variations.sum(&:price)
    render layout: false
  end
end
