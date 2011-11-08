class Admin::Users::EmailsController < Admin::UsersController
  before_filter :find_user

  def create
    @user.emails.push(params[:email]).compact!
    if @user.save
      flash[:notice] = 'Your email has been added.'
    else
      flash[:error] = "We couldn't add your email. Please try again."
    end
    redirect_to admin_user_path(@user.pretty_id)
  end

  def destroy
    email = @user.emails[params[:id].to_i]
    @user.emails.delete(email)
    @user.save
    flash[:notice] = "#{email} has been deleted"
    redirect_to admin_user_path(@user.pretty_id)
  end
end

