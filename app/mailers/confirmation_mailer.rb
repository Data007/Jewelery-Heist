class ConfirmationMailer < ActionMailer::Base
  default from: "services@wexfordjewlers.com"

  def send_user_confirmation_email user
    @order = user.orders.last
    mail(:to => user.email, :subject => "Test Email")
  end
end
