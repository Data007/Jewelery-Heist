class UsersController < ApplicationController
  before_filter :force_login, :except => [:new, :create, :forgot_password, :generate_new_password]

  layout 'account'

  def new
    @user = User.new
  end

  def create
    @user           = User.new(params[:user])
    @user.is_active = true

    if @user.save
      session[:user_id] = @user.id
      redirect_to [:account], flash: {notice: "Thank you for registering #{@user.full_name}! Welcome to Wexford Jewelers! We're very glad you joined!"}
    else
      flash[:error] = "We couldn't register you. Please check your details and try again."
      render template: 'users/new'
    end
  end
  
  def edit
  end
  
  def update
    @current_user.update_attributes params[:user]
    redirect_to [:profile]
   # @user     = current_user

    #emails    = params[:user].delete(:emails)
    #emails    = emails.collect {|(key,value)| value['address']}.flatten.reject(&:empty?).uniq

    #phones    = params[:user].delete(:phones)
    #phones    = phones.collect {|(key,value)| value['number']}.flatten.reject(&:empty?).uniq

    #if @user.update_attributes params[:user]
     # @user.emails = emails
      #@user.phones = phones
      #@user.save
      
      #flash[:notice] = "Your profile has been updated."
      #redirect_to_back_or_account
    #else
      #flash[:message] = ""
      #@user.errors.each {|error| flash[:message] += "<div class='error'>#{error}</div>"}
      #redirect_to dashboard_path
    #end
  end
  
  def forgot_password
  end

  def profile
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
  
  private
    def ssl_required?
      return action_name == "logout" ? false : true
    end
    
    def redirect_to_back_or_account
      next_page = session[:previous_page] ? session[:previous_page] : [:account]
      session[:previous_page] = nil
      redirect_to next_page
    end
    
    def redirect_back
      next_page = session[:previous_page] ? session[:previous_page] : :back
      session[:previous_page] = nil
      redirect_to next_page
    end
end
