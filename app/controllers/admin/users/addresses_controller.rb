class Admin::Users::AddressesController < Admin::UsersController
  before_filter :find_user

  def create
    address = @user.addresses.new params[:address]
    if address.save
      flash[:notice] = 'Your address has been added.'
    else
      flash[:error] = "We couldn't add your address. Please try again."
    end
    redirect_to admin_user_path(@user.pretty_id)
  end

  def destroy
    address = @user.addresses.find(params[:id])
    flash[:notice] = "#{address.to_single_line} has been deleted"
    address.destroy
    redirect_to admin_user_path(@user.pretty_id)
  end
end
