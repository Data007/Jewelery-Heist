require 'spec_helper'

describe 'Dashboard' do
  
  before do
    @user  = FactoryGirl.create :web_user
    @item  = FactoryGirl.create :item
    @asset = @item.assets.create
  end

  it 'Shows the dashboard after login' do
    login_with_dh @user.login, 'password'

    current_url.should == url_for([:account])
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
