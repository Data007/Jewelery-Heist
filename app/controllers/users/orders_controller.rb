class Users::OrdersController < UsersController
  before_filter :find_order, except: [:new, :create, :index]

  def show
  end

  private
  def find_order
    order_id = params[:order_id] ? params[:order_id] : params[:id]
    @current_order = @current_user.orders.where(pretty_id: order_id).first
  end 
end
