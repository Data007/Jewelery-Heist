class AdminController < ApplicationController
  layout 'admin'
  before_filter :force_admin, except: [:login, :logout, :authenticate]
  before_filter :check_for_sessioned_order

private
  def force_admin
    redirect_to login_admin_users_path unless (current_user && current_user.is_worker?)
    return true
  end

  def pagination_hash
    { per_page: 20, page: params[:page] || 1 }
  end

  def check_for_sessioned_order
    if session[:admin_order_id]
      @order = User.find_order(session[:admin_order_id])
      @user  = @order.user
    end
  end

  def get_workers
    @workers = User.workers
  end
end
