class Admin::Users::Orders::LineItemsController < Admin::Users::OrdersController
  before_filter :find_order

  def new
    variation = Item.find_variation(params[:variation_id])

    @order.add_item(variation, size: params[:item_size])

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def create
    @order.add_line_item params[:line_item]

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def destroy
    @order.line_items.where(pretty_id: params[:id]).destroy

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

  def refund
    @order.refund_line_item params[:id]

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end
end
