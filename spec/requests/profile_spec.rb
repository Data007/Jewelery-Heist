require 'spec_helper'

describe 'Profile' do
  before do
    @user = FactoryGirl.create :web_user
    @user.phones.create(number: '1234567890')
    @user.phones.create(number: '0987654321')

    @item = FactoryGirl.create :item
    @address = FactoryGirl.create :address, user: @user
    @credit_card = FactoryGirl.create :credit_card, user: @user
    
    login_with_dh @user.email, 'password'
  end

  context 'profile' do
    it 'navigates to the profile'  do
      current_url.should == url_for([:account])

      click_link 'Profile'
      current_url.should == url_for([:profile])
    end

    context 'with a user' do
      it 'displays the user information' do
        visit url_for([:profile])
        page.should have_content(@user.first_name)
        page.should have_content(@user.last_name)
        page.should have_content(@user.email)
        page.should have_content('Edit')
      end
    
      it 'edits the users info' do
        visit url_for([:profile])
        current_url.should == url_for([:profile])

        within '.profile' do
          click_link 'Edit'
        end
        current_url.should == url_for([:edit, @user])

        fill_in 'user_first_name', with: 'jujubear'
        fill_in 'user_last_name', with: 'bearsteinbears'
        fill_in 'user_email', with: 'lordbyron@ghy.iou'
        fill_in 'user_email_confirmation', with: 'lordbyron@ghy.iou'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'

        click_button 'Save'
        current_url.should == url_for([:profile])
      end
    end

    context 'phone numbers' do
      it 'adds a phone number' do
        @user.phones.count.should == 2
        visit url_for([:profile])

        within '.phones' do
          click_link 'New'
        end

        current_url.should == url_for([:new, @user, :phone])
        fill_in 'phone_number', with: '2314567890'
        click_button 'Save'

        current_url.should == url_for([:profile])

        @user.reload
        @user.phones.count.should == 3
      end

      it 'displays the users phones' do
        visit url_for([:profile])
        page.should have_content('Phones')
        page.should have_content(@user.phones.first.number)
        page.should have_content(@user.phones.last.number)
        page.should have_content('New')
        page.should have_content('Remove')
        page.should have_content('Edit')
      end

      it 'edits the phone number' do
        visit url_for([:profile])

        within '.phones' do
          click_link 'Edit'
        end

        fill_in 'phone_number' , with: '1234546689'
        click_button 'Save'

        @user.reload
        @user.phones.first.number.should == '1234546689'
        current_url.should == url_for([:profile])
      end

      it 'removes a phone number' do
        @phone = @user.phones.first
        visit url_for([:profile])

        page.should have_content(@phone.number)

        within "#phone_#{@phone.id}" do
          click_link 'Remove'
        end

        @user.reload
        -> {@user.phones.find(@phone.id)}.should raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end

    context 'with a address' do
      it 'adds a new address' do
        @user.addresses.count.should == 1
        visit url_for([:profile])

        within '.address' do
          click_link 'New'
        end

        current_url.should == url_for([:new, @user, :address])

        fill_in 'address_address_1', with: '2345 South Karmin Drve'
        fill_in 'address_city', with: 'vancouver'
        fill_in 'address_province', with: 'kanasa'
        fill_in 'address_postal_code', with: '97860'
        fill_in 'address_country', with: 'US' 
        click_button 'Save'

        @user.reload
        @user.addresses.count.should == 2
      end

      it 'displays the users addresses' do
        visit url_for([:profile])
        page.should have_content('Addresses')
        page.should have_content(@user.addresses.first.to_single_line)
        page.should have_content('New')
        page.should have_content('Remove')
        page.should have_content('Edit')
      end

      it 'edits a address' do
        visit url_for([:profile])

        within '.address' do
          click_link 'Edit'
        end
        fill_in 'address_address_1', with: '2345'
        fill_in 'address_city', with: 'vanco'
        fill_in 'address_province', with: 'kan'
        fill_in 'address_postal_code', with: '97'
        fill_in 'address_country', with: 'US' 
        click_button 'Save'

        @user.reload
        @user.addresses.first.address_1.should == '2345'
        current_url.should == url_for([:profile])
      end

      it 'removes a address' do
        @address = @user.addresses.first
        visit url_for([:profile])

        page.should have_content(@address.to_single_line)

        within "#address_#{@address.id}" do
          click_link 'Remove'
        end

        page.should_not have_content(@address.to_single_line)
        @user.reload
        -> {@user.addresses.find(@address.id)}.should raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end
  end
end
