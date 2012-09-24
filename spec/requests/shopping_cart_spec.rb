require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @user = FactoryGirl.create :user
    @item = FactoryGirl.create :item
  end

  context 'Shopping Cart' do
    it 'adds a item to the cart' do
      visit url_for([@item])

      binding.pry
      soap
      click_link 'Add to Cart'
      @user.cart.should == @item
    end
  end
end
