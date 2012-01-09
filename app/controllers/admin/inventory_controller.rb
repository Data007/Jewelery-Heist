class Admin::InventoryController < ApplicationController
  def index
    @variations = Item.available.map(&:variations).flatten.compact.select {|variation| !variation.archived}.flatten.compact
    render layout: false
  end
end
