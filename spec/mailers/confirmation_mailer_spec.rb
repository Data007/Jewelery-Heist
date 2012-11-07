require "spec_helper"

describe ConfirmationMailer do
  context 'with a ConfirmationMailer' do
    context 'with an order' do
      before do
        @user = FactoryGirl.create :web_user_with_test_email_address
      end
      it 'sends an email from the class methods to the user' do
        ConfirmationMailer.should be
        ConfirmationMailer.send_user_confirmation_email(@user).deliver
        ActionMailer::Base.deliveries.last.should be
      end
    end
  end
end
