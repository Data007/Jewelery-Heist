class Admin::UsersController < AdminController

  def dashboard
  end

  def login
    @user = User.new
  end

  def authenticate
    @current_user = User.authorize(params[:user][:login], params[:user][:password])
    session[:user_id] = @current_user.id
    
    if current_user
      flash[:notice] = "Welcome #{current_user.name}!"
      redirect_to admin_root_path
    else
      flash[:error] = "We could not log you in. Please try again."
      redirect_to login_admin_users_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to admin_root_path
  end

  def search
    @users = User.full_search(params[:user]).paginate(pagination_hash)
  end

  def show
    @user = User.find(params[:id])
  end

end
