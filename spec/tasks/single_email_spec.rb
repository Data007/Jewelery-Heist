require 'spec_helper'
require 'rake'

describe 'Email Migration' do
  before do
    @user = FactoryGirl.create :user
    @user.emails = ['bryan@deepwoodsbrigade.com', 'mike@deepwoodsbrigade.com']
  end

  context 'with a user with multiple emails' do
    it 'moves email into the one email' do
      @user.email = nil
      @user.save validate: false

      @user.email.should_not be
      @user.emails.should be
      first_email = @user.emails.first
        
      execute_rake('email.rake', 'one_email')  

      @user.reload
      @user.emails.should == []
      @user.email.should == first_email
    end
  end
end
