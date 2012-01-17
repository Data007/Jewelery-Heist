class Admin::Users::Orders::LineItemsController < Admin::Users::OrdersController
  before_filter :find_order

  def new
    item         = Item.where(pretty_id: params[:item_id]).first
    new_quantity = item.quantity - 1

    @order.add_item(item, size: params[:item_size])
    item.quantity = new_quantity
    item.save

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def create
    @order.add_line_item params[:line_item]

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def destroy
    line_item = @order.line_items.where(pretty_id: params[:id]).first
    line_item.remove_item
    line_item.destroy

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def refund
    @order.refund_line_item params[:id]

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end
end
