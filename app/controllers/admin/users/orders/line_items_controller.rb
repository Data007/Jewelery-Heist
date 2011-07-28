class Admin::Users::Orders::LineItemsController < Admin::Users::OrdersController
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
end
