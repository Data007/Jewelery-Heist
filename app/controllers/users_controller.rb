class UsersController < ApplicationController
  before_filter :force_login, :except => [:fb_authenticate, :login, :authenticate, :logout, :register, :registered, :forgot_password, :generate_new_password]
  # skip_after_filter :save_previous_page
  before_filter :force_add_email, :except => [:edit, :update, :fb_authenticate, :login, :authenticate, :logout, :register, :registered, :forgot_password, :generate_new_password]
  
  def fb_authenticate
    begin
      user = User.find_by_facebook_uid(params[:uid])
      session[:user_id] = user.id
      redirect_to_back_or_dashboard
    rescue
      user = User.create(:facebook_uid => params[:uid])
      session[:user_id] = user.id
      redirect_to_back_or_dashboard
    end
  end
  
  def register
    @user = User.new
    render :template => "users/login"
  end
  
  def registered
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Welcome to Wexford Jewelers! We're very glad you joined!"
      session[:user_id] = @user.id
      redirect_to_back_or_dashboard
    else
      flash[:error] = "We register you. Please check your details and try again."
      render :template => "users/login"
    end
  end
  
  def login
    # session[:previous_page] = request.referer
    @user = User.new
  end
  
  def authenticate
    # session[:previous_page] = request.referer unless request.referer == "/users/login"
    user = User.authorize(params[:user][:login], params[:user][:password])
    
    if user
      session[:user_id] = user.id
      flash[:notice] = "You have been successfully authenticated #{user.name}"
      redirect_to_back_or_dashboard
    else
      flash[:warning] = "Your username or password is incorrect"
      redirect_to login_users_path
    end
  end
  
  def dashboard
    @user = current_user
  end
  
  def edit
    @user = current_user
    render :template => "users/dashboard"
  end
  
  def update
    @user     = current_user

    emails    = params[:user].delete(:emails)
    emails    = emails.collect {|(key,value)| value['address']}.flatten.reject(&:empty?).uniq

    phones    = params[:user].delete(:phones)
    phones    = phones.collect {|(key,value)| value['number']}.flatten.reject(&:empty?).uniq

    if @user.update_attributes params[:user]
      @user.emails = emails
      @user.phones = phones
      @user.save
      
      flash[:notice] = "Your profile has been updated."
      redirect_to_back_or_dashboard
    else
      flash[:message] = ""
      @user.errors.each {|error| flash[:message] += "<div class='error'>#{error}</div>"}
      redirect_to dashboard_path
    end
  end
  
  def forgot_password
  end
  
  def generate_new_password
    @user = User.where(:emails.in => [params[:user][:email]])
    if @user.present?
      @user          = @user.first
      new_password   = @user.generate_new_password
      UserMailer.deliver_forgot_password(@user, new_password)
      flash[:notice] = "Your new password has been sent to your registered email address"
      redirect_back
    else
      flash[:error] = "<p>We could not find a user by that email address. Please try another email address.</p><p>If you continue having issues please <a href='#{about_us_path}#contact_us'>contact us</a> and we will try to fix the problem as soon as possible.</p>"
      redirect_to forgot_password_users_path
    end
  end
  
  def logout
    session[:user_id] = nil
    case request.referer
    when dashboard_path
      url = root_path
    when login_users_path
      url = root_path
    else
      url = :back
    end
    redirect_to url
  end
  
  private
    def ssl_required?
      return action_name == "logout" ? false : true
    end
    
    def redirect_to_back_or_dashboard
      next_page = session[:previous_page] ? session[:previous_page] : dashboard_path
      session[:previous_page] = nil
      redirect_to next_page
    end
    
    def redirect_back
      next_page = session[:previous_page] ? session[:previous_page] : :back
      session[:previous_page] = nil
      redirect_to next_page
    end
end
