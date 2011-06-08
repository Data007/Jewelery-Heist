class AdminController < ApplicationController
  layout "admin"
  before_filter :force_login, :except => [:login, :authenticate, :logout, :forgot]
  before_filter :exclude_guests
  skip_before_filter :current_order
  before_filter :current_customer_order
  before_filter :get_tickets_due
  before_filter :get_worker_list
  
  private
    def is_logged_in?
      if session[:user_id]
        begin
          @current_user = User.find(session[:user_id])
        rescue ActiveRecord::RecordNotFound
          return false
        end
        current_user
      else
        return false
      end
    end
    
    def force_login
      unless is_logged_in?
        redirect_to login_admin_users_path
      end
    end
    
    def pagination_hash
      super.merge({:per_page => params[:per_page].present? ? params[:per_page] : 12})
    end
    
    def exclude_guests
      if is_logged_in?
        current_role = @current_user.role.name.to_s
        case current_role
        when "guest"
          redirect_to root_path
        when "customer"
          redirect_to root_path
        else
          return true
        end
      else
        return true
      end
    end
    
    def find_order
      if params[:order_id]
        @order = Order.find(params[:order_id])
      elsif params[:id]
        @order = Order.find(params[:id])
      end
      
      session[:customer_order_id] = @order.id if @order
      
      current_customer_order.update_attributes :clerk => @current_user unless current_customer_order.clerk_id != nil
    end
    
    def current_customer_order
      if is_logged_in?
        if session[:customer_order_id] != nil
          begin
            session_order = Order.find(session[:customer_order_id])
            session[:customer_order_id] = session_order.id
            @order = session_order
          rescue; end
        else
          session_order = Order.create({:location => "instore", :staging_type => "purchase", :clerk_id => @current_user.id})
          session[:customer_order_id] = session_order.id
          @order = session_order
        end
        return @order ? @order : nil
      else
        return nil
      end
    end
    
    def stage=(url,method="post")
      current_customer_order.update_attributes :current_url => url, :current_head_method => method
      return stage
    end
    
    def stage
      return {:url => current_customer_order.current_url, :method => current_customer_order.current_head_method}
    end
    
    def force_stage
      stage = request.request_uri, request.request_method
    end
    
    def get_tickets_due
      if @current_user
        @tickets = @current_user.tickets.opened
        @assigned_tickets = Ticket.assigned
      end
    end
    
    def get_worker_list
      @workers = []
      (User.employees + User.managers + User.owners).each do |u|
        @workers.push u unless @workers.include? u
      end
      return @workers
    end
end
