class Admin::InventoryController < ApplicationController
  def index
    @variations = Item.available.map(&:variations)
      .flatten.compact
      .select {|variation| variation if !variation.archived && variation.quantity > 0}
      .flatten.compact
    render layout: false
  end
end
