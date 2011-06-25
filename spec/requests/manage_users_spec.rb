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
      @customer = Factory.create :customer
    end

    context 'finds a customer' do

      it 'finds a customer by name'
      it 'finds a customer by address'
      it 'finds a customer by phone'
      it 'finds a customer by email'

    end
    
    context 'create a customer' do
    
      it 'creates a customer directly'
      it 'creates a customer after a failed search'

    end

  end
    
end
