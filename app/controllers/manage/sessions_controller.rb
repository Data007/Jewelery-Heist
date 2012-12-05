class Manage::SessionsController < ManageController
  def create
    user = User.where(pin: params[:user][:pin]).first

    if user
      session[:manage_user_id] = user.id
      redirect_back_or_default
    else
      redirect_to [:manage, :authorize], flash: {error: 'That is an invalid ID'}
    end
  end
end
