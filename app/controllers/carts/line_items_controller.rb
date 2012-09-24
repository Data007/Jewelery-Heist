class Carts::LineItemsController < ApplicationController
  def create
    line_item = cart.line_items.create(params[:line_item].merge(item: Item.find(params[:item_id])))
    redirect_to :back, flash: {notice: "#{line_item.item.name.titleize} has been added to your cart"}
  end
end
