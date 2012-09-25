require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @user = FactoryGirl.create :user
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
    
    it 'adds an item to a cart and the user is logged in' do
      @user = User.where(email: 'dh@example.com').first
      @user.cart.should == nil

      visit item_path(@item.pretty_id)
      cart = Cart.last
      click_button 'Add to Cart'
      page.should have_content("#{@item.name.titleize} has been added to your cart")
      cart.reload
      cart.line_items.count.should == 1
      cart.line_items.map(&:item).include?(@item).should be
      click_link 'Check Out'

      current_url.should == url_for([:login])
      
      within '#login-form' do
        fill_in 'user_login', with: 'dh@example.com'
        fill_in 'user_password', with: 'password'
        click_button 'Login'
      end
      
      current_url.should == url_for([:account])
      @user.reload
      @user.cart.line_items.count.should == 1
    end

    it 'item alredy in cart, user logs in, merges cart' do
      #@user = User.where(email: 'dh@example.com').first
      #@user.cart = @item_2
      #@user.cart.line_items.count.should == 1
      #binding.pry
      
      visit item_path(@item.pretty_id)
      cart = Cart.last
      click_button 'Add to Cart'
      page.should have_content("#{@item.name.titleize} has been added to your cart")
      cart.reload
      cart.line_items.count.should == 1
      cart.line_items.map(&:item).include?(@item).should be
      click_link 'Check Out'

      current_url.should == url_for([:login])
      
      within '#login-form' do
        fill_in 'user_login', with: 'dh@example.com'
        fill_in 'user_password', with: 'password'
        click_button 'Login'
      end
      
      #current_url.should == url_for([:account])
      #@user.cart.count.should == 2
    end

    it 'guest registers, moves an item to his cart' do
      visit item_path(@item.pretty_id)
      cart = Cart.last

      click_button 'Add to Cart'
      page.should have_content("#{@item.name.titleize} has been added to your cart")
      cart.reload
      cart.line_items.count.should == 1
      cart.line_items.map(&:item).include?(@item).should be
      click_link 'Check Out'
      current_url.should == url_for([:login])

      within '#registration-form' do
        fill_in 'user_first_name', with: 'Web'
        fill_in 'user_last_name', with: 'User'
        fill_in 'user_email', with: 'wu@example.com'
        fill_in 'user_email_confirmation', with: 'wu@example.com'
        fill_in 'user_password', with: 'pass'
        fill_in 'user_password_confirmation', with: 'pass'
        click_button 'Register'
      end

      @user = User.where(first_name: 'Web').first
      @user.cart.line_items.count.should == 1
    end
  end
end
