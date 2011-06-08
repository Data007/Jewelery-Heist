class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :refresh_current_user_session, :current_order
  # after_filter :save_previous_page
  # before_filter :force_login, :except => [:login, :authenticate, :logout]
  # before_filter :is_logged_in?, :prepare_title #, :prepare_session
  # before_filter :prepare_session
  
  rescue_from ActionController::RoutingError do
    redirect_to bad_route_path
  end
  
private
  def current_page
    request.request_uri
  end

  def prepare_title
    @title = ": #{current_page}"
  end

  def pagination_hash
    {
      :page => ( params[:page] or 1 ),
      :per_page => ( params[:per_page] or 9 ),
      :order => "updated_at DESC"
    }
  end
  
  def ssl_allowed?
    return true
  end
  
  def prepare_session
    if !session[:expiry_time].nil? and session[:expiry_time] < Time.now
      # Session has expired. Clear the current session.
      reset_session
    end

    # Assign a new expiry time, whether the session has expired or not.
    session[:expiry_time] = 15.minutes.from_now
    return true
  end
  
  def refresh_current_user_session
    response.headers['Cache-Control'] = 'no-cache'
    is_logged_in?
    return true
  end
  
  def is_logged_in?
    begin
      @current_user = User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      return false
    end
  end
  
  def force_login
    unless is_logged_in?
      session[:previous_page] = request.referer
      redirect_to login_users_path
    end
  end
  
  def force_add_email
    if !current_user
      flash[:update] = "You must be logged in as a registered user in order to checkout"
      
      session[:previous_page] = request.referer
      redirect_to register_users_path
      
    elsif !current_user.email
      flash[:update] = "We do not have an email address for you. Please add it."
      session[:previous_page] = request.referer
      redirect_to edit_user_path(current_user.id)
      
    end
  end
  
  def current_user
    @current_user
  end
  
  def current_order
    @current_order = {}
    
    if session[:order_id].present?
      begin
        @current_order = Order.find(session[:order_id])
        @current_order = (@current_order.handed_off || @current_order.ghost) ? Order.create(:location => "website", :handed_off => false, :staging_type => "purchase") : @current_order
      rescue
        @current_order = Order.create(:location => "website", :handed_off => false, :staging_type => "purchase")
      end
    else
      @current_order = Order.create(:location => "website", :handed_off => false, :staging_type => "purchase")
    end
    
    session[:order_id] = @current_order.id
    
    return @current_order
  end
  
  def safe_find(&block)
    begin
      yield
    rescue
      flash[:error] = "We could not find anything like that. Sorry."
    end
  end
end
