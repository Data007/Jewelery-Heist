require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @user = FactoryGirl.create :user
    @item = FactoryGirl.create :item
  end

  context 'Shopping Cart' do
    it 'adds a item to the cart' do
      visit item_path(@item.pretty_id)

      click_link 'Add to Cart'
      @user.cart.should == @item
    end
  end
end
