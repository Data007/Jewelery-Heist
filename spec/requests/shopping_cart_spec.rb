require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @item = FactoryGirl.create :item
    @item_2 = FactoryGirl.create :item
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

    context 'with an item in a cart' do
      before do
        visit item_path(@item.pretty_id)
        @cart = Cart.last
        click_button 'Add to Cart'
      end

      it 'transfers cart to user after registration' do
        User.count.should == 0

        click_link 'Register'

        within '#registration-form' do
          fill_in 'user_first_name', with: 'Registered'
          fill_in 'user_last_name', with: 'User'
          fill_in 'user_email', with: 'registered-user@example.com'
          fill_in 'user_email_confirmation', with: 'registered-user@example.com'
          fill_in 'user_password', with: 'password'
          fill_in 'user_password_confirmation', with: 'password'

          click_button 'Register'
        end

        User.count.should == 1
        user = User.first

        @cart.reload
        @cart.user.should == user
      end
    end
  end

  context 'as a registered user' do
    before do
      @user = FactoryGirl.create :user
    end

    context 'with an item in an anonymous cart' do
      before do
        visit item_path(@item.pretty_id)
        @cart = Cart.last
        click_button 'Add to Cart'
      end

      it 'transfers anonymous cart to logged in user'
      
      context 'with a previous cart' do
        it 'merges anonymous cart with previous cart'
      end
    end
  end
end
