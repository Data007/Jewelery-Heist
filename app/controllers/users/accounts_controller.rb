class Users::AccountsController < UsersController
  before_filter :force_login

  def show
  end
end
