class Admin::Users::Orders::LineItemsController < Admin::Users::OrdersController
  def create
    @order.add_line_item params[:line_item]

    redirect_to [:admin, @user, @order]
  end
end
