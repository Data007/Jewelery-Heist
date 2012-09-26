class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.authorize(params[:user][:email], params[:user][:password])
    
    if @user
      session[:user_id] = @user.id
      redirect_to [:account], flash: {notice: "You have been successfully authenticated #{@user.full_name}"}
    else
      redirect_to [:login], flash: {warning: "Your email or password is incorrect"}
    end 
  end

  def destroy
    session[:user_id] = nil
    redirect_to [:root]
  end
end
