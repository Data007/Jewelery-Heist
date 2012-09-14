require 'spec_helper'

describe 'Profile' do
  before do
    @user = FactoryGirl.create :web_user
    @item = FactoryGirl.create :item
    @address = FactoryGirl.create :address, user: @user
    
    login_with_dh @user.email, 'password'
  end

  context 'profile' do
    it 'navigates to the profile'  do
      current_url.should == url_for([:account])

      click_link 'Profile'
      current_url.should == url_for([@user, :profile])
    end
  end

end
