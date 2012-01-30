# encoding: UTF-8

require 'spec_helper'

describe 'Manage Users' do

  before do
    @admin = Factory.create :admin
  end

  context 'admins' do

    it 'logs in to manage' do
      pending 'Major overhaul'
      visit admin_root_path

      fill_in 'Login',    with: @admin.login
      fill_in 'Password', with: 'password'
      click_button 'Login'

      page.should have_content("Welcome #{@admin.name}!")
    end

    it 'logs out the user' do
      pending 'Major overhaul'
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
        pending 'Major overhaul'
        visit admin_root_path

        fill_in 'Name', with: @customer.name
        within('#search-customers') do
          click_button 'search'
        end

        click_link @customer.name
        page.should have_content(@customer.name)
      end

      it 'by address' do
        pending 'Major overhaul'
        visit admin_root_path

        fill_in 'Address 1', with: 'circ'
        fill_in 'State / Province', with: 'Mi'
        within('#search-customers') do
          click_button 'search'
        end

        click_link @customer.name
        page.should have_content(@customer.name)
      end

      it 'by phone' do
        pending 'Major overhaul'
        visit admin_root_path

        fill_in 'Phone Number', with: '884-3024'
        within('#search-customers') do
          click_button 'search'
        end

        click_link @customer.name
        page.should have_content(@customer.name)
      end
        
      it 'by email' do
        pending 'Major overhaul'
        visit admin_root_path

        fill_in 'Email', with: 'customer_1'
        within('#search-customers') do
          click_button 'search'
        end

        click_link @customer.name
        page.should have_content(@customer.name)
      end


    end
    
    context 'creates' do
    
      it 'after a failed search' do
        pending 'Major overhaul'
        visit admin_root_path

        fill_in 'Name', with: 'Buster Bluth'
        within('#search-customers') do
          click_button 'search'
        end

        click_link 'Create a new user'
        click_button 'save'

        page.should have_content('Buster Bluth has been saved.')
        page.should have_content('Viewing Buster Bluth')
      end

      it 'directly' do
        pending 'Major overhaul'
        visit admin_root_path

        click_link 'Create a new user'
        fill_in 'Name', with: 'Buster Bluth'
        click_button 'save'

        page.should have_content('Buster Bluth has been saved.')
        page.should have_content('Viewing Buster Bluth')
      end

    end

  end
    
end
