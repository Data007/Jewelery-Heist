require 'spec_helper'

describe 'Shopping Cart' do
  before do
    @item = FactoryGirl.create :item
    @item_2 = FactoryGirl.create :item, name: 'item two', price: 50
    @item_backorder = FactoryGirl.create :item, name: 'item back order', price: 60, quantity: 0
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

        click_link "Cart (#{@cart.line_items.count})"
        current_url.should == url_for([:cart])

        @cart.line_items.first.item.name.should be
        @cart.line_items.first.item.price.should be
        @cart.line_items.first.item.quantity.should be
        
        page.should have_content(@cart.line_items.first.item.description)
        page.should have_content(@cart.line_items.first.price)
        page.should have_content(@cart.line_items.first.quantity)
      end

      it 'views the back order confirmation' do
        visit url_for([:root])
        @cart.line_items = nil
        @cart.reload

        visit item_path(@item_backorder.pretty_id)
        click_button 'Add to Cart'
        @cart.reload
        click_link "Cart (#{@cart.line_items.count})"
        current_url.should == url_for([:cart])

        page.should have_content(@item_backorder.backorder_notes)
        
        @cart.line_items = nil
        visit item_path(@item.pretty_id)
        click_button 'Add to Cart'
        @cart.reload
        click_link "Cart (#{@cart.line_items.count})"

        page.should_not have_content(@item.backorder_notes)
      end
  
      context 'starts the checkout process' do
        before do
          click_link "Cart (#{@cart.line_items.count})"
          click_button 'Next'
          current_url == url_for([:checkout])
          click_button 'Next'
        end

        it 'validates shipping address line 1' do
          page.should have_content("Address line 1 can't be blank")
          fill_in 'cart_shipping_address_address_1', with: 'W. side foo'
          click_button 'Next'
          page.should_not have_content("Address line 1 can't be blank")
        end

        it 'validates shipping address city' do
          page.should have_content("City can't be blank")
          fill_in 'cart_shipping_address_city', with: 'la'
          click_button 'Next'
          page.should_not have_content("City can't be blank")
        end

        it 'validates shipping address province' do
          page.should have_content("State or province can't be blank")
          fill_in 'cart_shipping_address_province', with: 'CA'
          click_button 'Next'
          page.should_not have_content("State or province can't be blank")
        end

        it 'validates shipping address postal code' do
          page.should have_content("Postal Code can't be blank")
          fill_in 'cart_shipping_address_postal_code', with: '34567'
          click_button 'Next'
          page.should_not have_content("Postal Code can't be blank")
        end

        it 'validates shipping address country' do
          page.should have_content("Country can't be blank")
          fill_in 'cart_shipping_address_country', with: 'US'
          click_button 'Next'
          page.should_not have_content("Country can't be blank")
        end

        it 'validates email' do
          page.should have_content("Email can't be blank")
          fill_in 'cart_email', with: 'd'
          click_button 'Next'
          page.should have_content("d is not a proper email")
          page.should_not have_content("Email can't be blank")
          fill_in 'cart_email', with: 'thejoker@deepwoodsbrigade.com'
          click_button 'Next'
          page.should_not have_content("d is not a proper email")
          page.should_not have_content("Email can't be blank")
        end

        it 'validates phone' do
          page.should have_content("Phone can't be blank")
          fill_in 'cart_phone', with: '1'
          click_button 'Next'

          page.should have_content('1 is not a proper phone number. Example: (231)775-1289')
          page.should_not have_content("Phone can't be blank")

          fill_in 'cart_phone', with: '2319203456'
          click_button 'Next'
          page.should_not have_content('1 is not a proper phone number, Example: (231)775-1289')
          page.should_not have_content("Phone can't be blank")         
        end

        it 'validates first name' do
          page.should have_content("First Name can't be blank")
          fill_in 'cart_first_name', with: 'george'
          click_button 'Next'
          page.should_not have_content("First Name can't be blank")
        end

        it 'validates last name' do
          page.should have_content("Last Name can't be blank")
          fill_in 'cart_last_name', with: 'omallie'
          click_button 'Next'
          page.should_not have_content("Last Name can't be blank")
        end

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

          click_button 'Next'

          current_url.should == url_for([:pay])

          @cart.reload
          @cart.shipping_address.address_1.should == '3456 S. gigiidy RD'
          @cart.shipping_address.city.should == 'goo'
          @cart.shipping_address.province.should == 'MI'
          @cart.shipping_address.postal_code.should == '45637'
          @cart.shipping_address.country.should == 'US'
          @cart.email.should == 'bugsbunny@gmail.com'  
          @cart.phone.should == '2314567890'
          @cart.current_stage.should == 'pay'
        end

        context 'paying for cart' do
          before do
            @cart = FactoryGirl.create :anonymous_cart_ready_for_payments
            visit url_for([:pay])
          end

          context 'and validating credit card' do
            before do
              click_button 'Next'
            end

            it 'validates number' do
              page.should have_content("Number can't be blank")
              fill_in 'cart_credit_card_number', with: '4111111111111111'
              click_button 'Next'
              page.should_not have_content("Card number can't be blank")
            end

            it 'validates ccv' do
              page.should have_content("Ccv can't be blank")
              fill_in 'cart_credit_card_ccv', with: '111'
              click_button 'Next'
              page.should_not have_content("Ccv can't be blank")
            end

            it 'validates name'
            it 'validates billing address'
          end

          context 'with valid card' do
            it 'processes payment'
            it 'shows an order summary'
          end
        end
      end
    end
  end

  context 'as a registered user' do
    before do
      @user    = FactoryGirl.create :web_user_with_address
      @address = @user.addresses.first
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

      context 'starts the checkout process' do
        before do
          login_with_dh('dh@example.com', 'password')
          click_link 'Check Out'
          current_url == url_for([:checkout])
        end

        it 'shows the cart in the check out process' do
          page.should have_content(@item.description)
          page.should have_content(@item.price)
        end

        it 'picks a shipping address' do
          page.should_not have_content ('cart_first_name')
          page.should_not have_content ('cart_last_name')
          page.should_not have_content ('cart_shipping_address_address_1')
          page.should_not have_content ('cart_shipping_address_city')
          page.should_not have_content ('cart_shipping_address_province')
          page.should_not have_content ('cart_shipping_address_postal_code')
          page.should_not have_content ('cart_shipping_address_country')
          page.should_not have_content ('cart_email')
          page.should_not have_content ('cart_phone')

          page.should have_content(@address.to_single_line)
          choose("cart_shipping_address_#{@address.id}")
          click_button 'Next'

          current_url.should == url_for([:pay])

          @cart.reload
          @cart.shipping_address.to_single_line.should == @address.to_single_line
        end
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
