require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @item = FactoryGirl.create :item
    @item_2 = FactoryGirl.create :item, name: 'item two', price: 50
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
        @cart.reload
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
        
      it 'views the cart' do
        visit url_for([:root])

        click_link "Cart(#{@cart.line_items.count})"
        current_url.should == url_for([:cart])

        @cart.line_items.first.item.name.should be
        @cart.line_items.first.item.price.should be
        @cart.line_items.first.item.quantity.should be
        
        page.should have_content(@cart.line_items.first.item.name)
        page.should have_content(@cart.line_items.first.price)
        page.should have_content(@cart.line_items.first.quantity)
        page.should have_link('Delete')
      end

      context 'starts the checkout process' do
        before do
          click_link 'Check Out'
          current_url == url_for([:checkout])
          click_button 'Save'
        end

        it 'validates shipping address line 1' do
          page.should have_content("Address line 1 can't be blank")
          fill_in 'cart_shipping_address_address_1', with: 'W. side foo'
          click_button 'Save'
          page.should_not have_content("Address line 1 can't be blank")
        end

        it 'validates shipping address city' do
          page.should have_content("City can't be blank")
          fill_in 'cart_shipping_address_city', with: 'la'
          click_button 'Save'
          page.should_not have_content("City can't be blank")
        end

        it 'validates shipping address province' do
          page.should have_content("State or province can't be blank")
          fill_in 'cart_shipping_address_province', with: 'CA'
          click_button 'Save'
          page.should_not have_content("State or province can't be blank")
        end

        it 'validates shipping address postal code' do
          page.should have_content("Postal Code can't be blank")
          fill_in 'cart_shipping_address_postal_code', with: '34567'
          click_button 'Save'
          page.should_not have_content("Postal Code can't be blank")
        end

        it 'validates shipping address country' do
          page.should have_content("Country can't be blank")
          fill_in 'cart_shipping_address_country', with: 'US'
          click_button 'Save'
          page.should_not have_content("Country can't be blank")
        end
        it 'validates email'
        it 'validates phone'
        it 'validates first name'
        it 'validates last name'

        it 'fills in the Shipping Address, name, email, phone' do
          fill_in 'cart_first_name', with: 'Anonymous'
          fill_in 'cart_last_name', with: 'User'
          fill_in 'cart_shipping_address_address_1', with: '3456 S. gigiidy RD'
          fill_in 'cart_shipping_address_city', with: 'goo'
          fill_in 'cart_shipping_address_province', with: 'MI'
          fill_in 'cart_shipping_address_postal_code', with: '45637'
          fill_in 'cart_shipping_address_country', with: 'US'
          fill_in 'cart_email', with: 'bugsbunny@gmail.com'
          fill_in 'cart_phone', with: '2314567890'

          click_button 'Save'

          @cart.reload
          @cart.shipping_address.address_1.should == '3456 S. gigiidy RD'
          @cart.shipping_address.city.should == 'goo'
          @cart.shipping_address.province.should == 'MI'
          @cart.shipping_address.postal_code.should == '45637'
          @cart.shipping_address.country.should == 'US'
          @cart.email.should == 'bugsbunny@gmail.com'  
          @cart.phone.should == '2314567890'
        end
      end

      context 'paying for cart' do
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

      it 'transfers anonymous cart to logged in user' do
        fill_in 'user_email', with: @user.email
        fill_in 'user_password', with: 'password'

        click_button 'Login'

        @cart.reload
        @cart.user.should == @user
      end
      
      context 'with a previous cart' do
        before do
          @old_cart = FactoryGirl.create :cart, user: @user
          @old_cart.line_items.create item: @item_2
        end

        it 'merges anonymous cart with previous cart' do
          @user.reload
          @user.cart.should == @old_cart

          fill_in 'user_email', with: @user.email
          fill_in 'user_password', with: 'password'

          click_button 'Login'

          @user.reload
          @user.cart.should == @cart

          @cart.reload
          @cart.user.should == @user
          
          @cart.line_items.count.should == 2
          @cart.line_items.map(&:item).include?(@item_2).should be
        end
      end
    end
  end
end
