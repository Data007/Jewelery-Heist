require 'spec_helper'

describe 'Dashboard' do
  
  before do
    binding.pry
    @user = FactoryGirl.create :web_user, name: 'temp1'
    @item = FactoryGirl.create :item
    @asset = FactoryGirl.create :asset, item_id: @item.id

    login_with_dh @user.login, 'password'
  end

  it 'Shows the dashboard after login' do
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
