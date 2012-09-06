require 'spec_helper'

describe 'Dashboard' do
  
  before do
    @user = FactoryGirl.create :web_user

    login_with_dh @user.login, 'password'
  end

  it 'shows the dashboard after login' do
    current_url.should == url_for([:dashboard])
  end
  
  context 'cart' do
    it 'shows an item in my cart'
  end
  
  context 'orders' do
    it 'shows my past orders'
  end

  context 'payments' do
    it 'shows my past payments'
  end
end
