class Admin::Users::PhonesController < Admin::UsersController
  before_filter :find_user

  def create
    @user.phones.push(params[:phone]).compact!
    if @user.save
      flash[:notice] = 'Your phone has been added.'
    else
      flash[:error] = "We couldn't add your phone. Please try again."
    end
    redirect_to admin_user_path(@user.pretty_id)
  end

  def destroy
    phone = @user.phones[params[:id].to_i]
    @user.phones.delete(phone)
    @user.save
    flash[:notice] = "#{params[:id]} has been deleted"
    redirect_to admin_user_path(@user.pretty_id)
  end
end

