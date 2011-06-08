class Admin::CustomersController < AdminController
  def index
    @customers = User.customers.paginate(pagination_hash)
  end
  
  def show
    @customer = User.find(params[:id])
    @orders   = @customer.orders.paginate(pagination_hash.merge!({:page => (params[:orders_page] or 1)}))
    @payments = @customer.payments.paginate(pagination_hash.merge!({:page => (params[:payments_page] or 1)}))
  end
end
