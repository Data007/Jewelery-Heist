require 'spec_helper'

describe User do
  context 'with a user' do
    before do
      @user = FactoryGirl.create :user
    end

    context 'access pin' do
      subject {@user.pin}
      it {should be}
    end

    it 'validates correct input for emails' do
      @user.update_attributes!(email: 'donald_duck@mickeyscastle.com', email_confirmation: 'donald_duck@mickeyscastle.com')
      @user.email.should == 'donald_duck@mickeyscastle.com'

      ->{@user.update_attributes!(email: 'three', email_confirmation: 'three')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'donald_duck@mickeyscastle.com'


      @user.update_attributes!(email: 'bryan@deewoodsbigade.com', email_confirmation: 'bryan@deewoodsbigade.com')
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'

      ->{@user.update_attributes!(email: 'three@universal.pasta.sauce', email_confirmation: 'three@universal.pasta.sauce')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'
      
      ->{@user.update_attributes!(email: 'three@', email_confirmation: 'three@')}.should raise_error(Mongoid::Errors::Validations)
      @user.reload
      @user.email.should == 'bryan@deewoodsbigade.com'
    end
  end
end
