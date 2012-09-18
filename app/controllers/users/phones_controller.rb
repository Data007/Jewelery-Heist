class Users::PhonesController < UsersController
  before_filter :force_login

  def new
    @phone = @current_user.phones.new
  end

  def create
    @phone = @current_user.phones.create(params[:phone])
    redirect_to [:profile]
  end

  def destroy
    @current_user.phones.find(params[:id]).destroy
    redirect_to [:profile]
  end
end
