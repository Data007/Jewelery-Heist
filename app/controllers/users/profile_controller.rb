class Users::ProfileController < UsersController
  before_filter :force_login, :except => [:new, :create, :forgot_password, :generate_new_password]

  def show
  end

  def profile
  end
end
