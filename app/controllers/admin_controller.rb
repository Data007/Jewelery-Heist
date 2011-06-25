class AdminController < ApplicationController
  layout 'admin'
  before_filter :force_admin, except: [:login, :logout, :authenticate]

private
  def force_admin
    redirect_to login_admin_users_path unless (current_user && current_user.is_admin?)
    return true
  end
end
