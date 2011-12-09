class Admin::Users::Orders::PaymentsController < Admin::Users::OrdersController
  before_filter :find_order

  def create
    @order.payments.create(params[:payment])
    @order.hand_off

    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end
  
  def destroy
    @payment = @order.payments.find(params[:id])
    @order.payments << @order.payments.create(amount: -(@payment.amount), payment_type: 'instorecredit', check_number: @payment.check_number)
    redirect_to admin_user_order_path(@user.pretty_id, @order.pretty_id)
  end

end
