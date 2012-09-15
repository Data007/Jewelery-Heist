require 'spec_helper'

describe 'Profile' do
  before do
    @user = FactoryGirl.create :web_user, phones: ['17862345673', '16579872635']
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

    it 'displays the user information' do
      visit url_for([@user, :profile])
      page.should have_content(@user.first_name)
      page.should have_content(@user.last_name)
      page.should have_content(@user.email)
      page.should have_content('Edit')
    end
    
    it 'displays the users addresses' do
      visit url_for([@user, :profile])
      page.should have_content('Addresses')
      page.should have_content(@user.addresses.first.to_single_line)
      page.should have_content('New')
      page.should have_content('Remove')
      page.should have_content('Edit')
    end

    it 'displays the users phones' do
      visit url_for([@user, :profile])
      page.should have_content('Phones')
      page.should have_content(@user.phones.first)
      page.should have_content(@user.phones.last)
      page.should have_content('New')
      page.should have_content('Remove')
      page.should have_content('Edit')
    end
  end

end
