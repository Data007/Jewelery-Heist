class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authorize(params[:user][:login], params[:user][:password])
    
    if user
      session[:user_id] = user.id
      redirect_to [:dashboard], flash: {notice: "You have been successfully authenticated #{user.name}"}
    else
      redirect_to [:login], flash: {warning: "Your username or password is incorrect"}
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to [:root]
  end
end
