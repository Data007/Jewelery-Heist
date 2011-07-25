class Admin::Users::OrdersController < Admin::UsersController
  before_filter :find_user
  before_filter :find_order, except: [:new]

  def new
    @order = @user.orders.create({
      purchased:    true,
      location:     (params[:location]     || 'instore'),
      staging_type: (params[:staging_type] || 'purchase')
    })

    redirect_to [:admin, @user, @order]
  end

  def show
    render template: "admin/users/orders/show_#{@order.location}_#{@order.staging_type}"
  end

  def update
    redirect_to [:admin, @user, @order]
  end

private
  
  def find_order
    @order = @user.orders.find(params[:id])
  end

end
