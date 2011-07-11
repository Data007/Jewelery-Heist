# encoding: UTF-8

require 'spec_helper'

describe 'Manage Users' do

  before do
    @admin = Factory.create :admin
  end

  context 'admins' do

    it 'logs in to manage' do
      visit admin_root_path

      fill_in 'Login',    with: @admin.login
      fill_in 'Password', with: 'password'
      click_button 'Login'

      page.should have_content("Welcome #{@admin.name}!")
    end

    it 'logs out the user' do
      login_admin(@admin, 'password')
      page.should have_content("Welcome #{@admin.name}!")
      
      click_link 'Log Out'

      page.should have_content('Login')
    end

  end

  context 'customers' do

    before do
      @customer = Factory.create :customer, phones: ['231-884-3024'], emails: ['customer_1@example.net']
      @customer.addresses.create!({
        address_1:   '1 CIRCULAR DR',
        city:        'LOGIC',
        province:    'MI',
        postal_code: '49601'
      })

      login_admin(@admin, 'password')
    end

    context 'finds' do

      it 'by name' do
        visit admin_root_path

        fill_in 'Name', with: @customer.name
        click_button 'search'

        click_link @customer.name
        page.should have_content(@customer.name)
      end

      it 'by address' do
        visit admin_root_path

        fill_in 'Address 1', with: 'circ'
        fill_in 'State / Province', with: 'Mi'
        click_button 'search'

        click_link @customer.name
        page.should have_content(@customer.name)
      end

      it 'by phone' do
        visit admin_root_path

        fill_in 'Phone Number', with: '884-3024'
        click_button 'search'

        click_link @customer.name
        page.should have_content(@customer.name)
      end
        
      it 'by email' do
        visit admin_root_path

        fill_in 'Email', with: 'customer_1'
        click_button 'search'

        click_link @customer.name
        page.should have_content(@customer.name)
      end


    end
    
    context 'creates' do
    
      it 'after a failed search'
      it 'directly'

    end

  end
    
end
