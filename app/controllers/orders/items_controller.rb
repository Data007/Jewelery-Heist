class Orders::ItemsController < ApplicationController
  def index
    @line_items = current_order.line_items
    @line_items.each do |line_item|
      line_item.destroy if !line_item.variation.parent_item.available
    end
    redirect_to order_path(current_order.id)
  end
  
  def create
    variation = Item.find_variation(params[:id])
    if variation.parent_item.available
      line_item = current_order.line_items.create(
        variation: variation,
        price:     variation.price,
        size:      (params[:item_size].present? ? params[:item_size] : variation.item.sizes.first)
      )

      flash[:notice] = "Your item has been added"
      redirect_to order_path(current_order.id)
    else
      flash[:notice] = "This item is no longer available"
      redirect_to order_path(current_order.id)
    end
  end
  
  def update
    line_item.update_attributes params[:line_item]
  end
  
  def destroy
    line_item.destroy
    redirect_to order_path(current_order.id)
  end
  
  private
    def line_item
      return @line_item ||= Order.find_line_item(params[:id])
    end
    
    def line_item=(new_line_item)
      @line_item = line_item
      return @line_item
    end
end
