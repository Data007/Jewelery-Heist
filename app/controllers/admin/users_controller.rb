class Admin::UsersController < AdminController
  # -- Start Authentication --
    def logout
      session[:user_id] = nil
      flash[:notice] = "You have been logged out"
      redirect_to login_admin_users_path
    end
    
    def authenticate
      user = User.is_authentic(params[:user][:login], params[:user][:password])
      if user
        session[:user_id] = user.id
        flash[:notice] = "You have been successfully authenticated #{user.name}"
        redirect_to admin_root_path
      else
        flash[:warning] = "Your username or password is incorrect"
        redirect_to login_admin_users_path
      end
    end
    
    def send_password
    end
  # -- End Authentication --
  
  def dashboard
    @latest_website_orders = Order.registered.website
    @latest_instore_orders = Order.registered.instore
  end
  
  def index
    @users = User.paginate(pagination_hash)
    @title = "Viewing All Users"
  end
  
  def list
    @users = User.list(params[:id]).paginate(pagination_hash)
    @title = "Viewing all #{params[:id].to_s.capitalize}"
    render :template => "users/index"
  end
  
  def new
    @user = User.new
  end
  
  def create
    user = User.new(params[:user])
    if user.save
      flash[:notice] = "#{user.name} was created successfully."
    else
      flash[:error] = "We could not create a user for #{user.name}. Please try again."
    end
    redirect_to previous_page_path
  end
  
  def show
    @user     = User.find(params[:id])
    @orders   = @user.orders.paginate(pagination_hash.merge!({:page => (params[:orders_page] or 1)}))
    @payments = @user.payments.paginate(pagination_hash.merge!({:page => (params[:payments_page] or 1)}))
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    user = User.find(params[:id])
    user.password = params[:user][:password]
    if user.update_attributes params[:user]
      flash[:notice] = "#{user.name} was updated successfully."
      redirect_to previous_page_path
    else
      flash[:error] = "We were not able to update #{user.name}. Please try again."
      redirect_to edit_admin_user_path(params[:id])
    end
  end
  
  def destroy
    begin
      @current_user.may_destroy_user! User.new
      User.find(params[:id]).destroy
      redirect_to admin_users_path
    rescue
      flash[:error] = "You do not have permission to create or cancel users"
      redirect_to admin_user_path(params[:id])
    end
  end
end
