class Users::PhonesController < UsersController
  before_filter :force_login
  before_filter :find_phone, except: [:new, :create, :index]

  def new
    @phone = @current_user.phones.new
  end

  def create
    @phone = @current_user.phones.create(params[:phone])
    redirect_to [:profile]
  end

  def update
    @phone.update_attributes params[:phone]
    redirect_to [:profile] 
  end

  def destroy
    @current_user.phones.find(params[:id]).destroy
    redirect_to [:profile]
  end

  private
  def find_phone
    phone_id = params[:phone_id] ? params[:phone_id] : params[:id]
    @phone = @current_user.phones.find(phone_id)
  end
end
