class Carts::LineItemsController < ApplicationController
  before_filter :find_line_item, except: [:new, :create]

  def create
    line_item = cart.line_items.create(params[:line_item].merge(item: Item.find(params[:item_id])))
    redirect_to :back, flash: {notice: "#{line_item.item.name.titleize} has been added to your cart"}
  end

  def destroy
    @line_item.destroy 
    redirect_to :back
  end

private
  def find_line_item
    line_item_id = params[:line_item].present? ? params[:line_item_id] : params[:id]
    @line_item = cart.line_items.find(line_item_id)
  end
end
