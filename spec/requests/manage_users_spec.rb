# encoding: UTF-8

require 'spec_helper'

describe 'Manage Users' do

  before do
    @admin = Factory.create :admin
  end

  context 'authenticate an admin' do

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

  context 'manage customers' do

    before do
      @customer = Factory.create :customer
    end

  end
    
end
