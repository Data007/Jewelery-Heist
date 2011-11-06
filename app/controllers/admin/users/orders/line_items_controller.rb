class Admin::Users::Orders::LineItemsController < Admin::Users::OrdersController
  before_filter :find_order, :only => [:show, :force_lookup, :refund, :address, :update, :print]

  def new
    item = Item.where('variations._id' => params[:variation_id]).first
    variation = item.variations.find(params[:variation_id])

    @order.add_item(variation, size: params[:item_size])

    redirect_to [:admin, @user, @order]
  end

  def create
    @order.add_line_item params[:line_item]

    redirect_to [:admin, @user, @order]
  end

  def refund
    @order.refund_line_item params[:id]

    redirect_to [:admin, @user, @order]
  end
end
