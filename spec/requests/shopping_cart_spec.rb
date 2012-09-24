require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @user = FactoryGirl.create :user
    @item = FactoryGirl.create :item
  end

  context 'as an Anonymous User' do
    it 'adds a item to the cart' do
      visit item_path(@item.pretty_id)
      cart = Cart.last

      click_button 'Add to Cart'
      page.should have_content("#{@item.name.titleize} has been added to your cart")
      cart.reload
      cart.line_items.count.should == 1
      cart.line_items.map(&:item).include?(@item).should be
    end
  end
end
