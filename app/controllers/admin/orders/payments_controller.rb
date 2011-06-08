class Admin::Orders::PaymentsController < AdminController
  before_filter :force_stage, :only => [:index]
  before_filter :find_order
  def index
    if params[:order]
      @order.update_attributes :shipping_option => params[:order][:shipping_option], :ship => params[:order][:ship]
      if params[:order][:line_items]
        params[:order][:line_items].each do |line_item|
          line_item[:taxable] = false unless line_item[:taxable]
          @order.line_items.find(line_item[:id]).update_attributes line_item
        end
      end
    end
    @payments = @order.payments
    redirect_to admin_order_path(@order)
  end
  
  def create
    @payment = Payment.create(params[:payment])
    @order.payments << @payment
    @order.update_attributes :purchased_at => @payment.created_at if @order.purchased_at == nil
    @order.ticket.current_stage = "payments"
    if @order.balance < @order.total
      @order.line_items.each do |li|
        unless li.is_quick_item
          li.variation.item.update_attributes :available => false if li.variation.item.one_of_a_kind
          li.variation.update_attributes :quantity => (li.variation.quantity - li.quantity) if li.variation.quantity > 0
        end
      end
    end
    redirect_to admin_order_path(@order)
  end
  
  def destroy
    @payment = Payment.find(params[:id])
    @order.payments << Payment.create(:amount => -(@payment.amount), :payment_type_id => @payment.payment_type_id, :check_number => @payment.check_number)
    redirect_to admin_order_path(@order)
  end
end
