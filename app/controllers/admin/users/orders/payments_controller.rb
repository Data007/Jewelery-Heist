class Admin::Users::Orders::PaymentsController < Admin::Users::OrdersController

  def create
    @order.payments.create(params[:payment])

    redirect_to [:admin, @user, @order]
  end

end
