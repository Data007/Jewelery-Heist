class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

private

  def current_user
    return nil unless session[:user_id]
    begin
      @current_user = User.find(session[:user_id])
    rescue; end
  end

end
