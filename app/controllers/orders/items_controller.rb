class Orders::ItemsController < ApplicationController
  def index
    @line_items = current_order.line_items
    @line_items.each do |line_item|
      line_item.destroy if !line_item.variation.item.available
    end
    redirect_to order_path(current_order.id)
  end
  
  def create
    variation = Variation.find(params[:id])
    if variation.item.available
      variation_included = false
      current_order.line_items.each do |li|
        if li.variation_id == variation.id && !li.ghost
          variation_included = true
          break
        end
      end
      unless variation_included
        line_item = LineItem.create(:price => variation.price, :variation_id => variation.id, :quantity => 1, :ghost => false, :size => (params[:item_size] ? params[:item_size] : variation.item.sizes[0]))
        current_order.line_items << line_item
      end
      respond_to do |format|
        format.html do
          if variation_included
            flash[:notice] = "This item is already in your cart"
            redirect_to order_path(current_order.id)
          else
            flash[:notice] = "Your item has been added"
            redirect_to order_path(current_order.id)
          end
        end
      end
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
      return @line_item ||= LineItem.find(params[:id])
    end
    
    def line_item=(new_line_item)
      @line_item = line_item
      return @line_item
    end
end
