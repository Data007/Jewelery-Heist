class UserMailer < ActionMailer::Base
  default :from => "info@wexfordjewelers.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.forgot_password.subject
  #
  def forgot_password user, password
    @user     = user
    @password = password

    mail :to => user.emails.first, :subject => 'Wexford Jewelers : Forgotten Password'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.order_completed.subject
  #
  def order_completed user, order
    @user  = user
    @order = order

    mail :to => user.emails.join(', '), :bcc => 'management@wexfordjewelers.com', :subject => "Wexford Jewelers : Your Order ##{order.pretty_id}"
  end
end
