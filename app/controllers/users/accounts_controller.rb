class Users::AccountsController < ApplicationController
  before_filter :force_login

  def show
  end
end
