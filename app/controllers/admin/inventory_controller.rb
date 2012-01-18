class Admin::InventoryController < ApplicationController
  def index
    @items = Item.where(available: true).excludes(quantity: 0)
    @quantity_total = @items.map(&:quantity).sum
    @retail_total   = @items.map(&:price).sum
    render layout: false
  end
end
