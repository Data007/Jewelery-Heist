require 'spec_helper'

describe 'Web User Registration' do
  before do
    FactoryGirl.create(:item).assets.create
  end

  context 'for a dragonhoard user' do
    before do
      visit url_for([:root])
      click_link 'Register'
      click_button 'Register'
    end

    it 'validates first name' do
      page.should have_content('You must provide a first name')

      fill_in 'user_first_name', with: 'Web'
      click_button 'Register'

      page.should_not have_content('You must provide a first name')
    end

    it 'validates last name' do
      page.should have_content('You must provide a last name')

      fill_in 'user_last_name', with: 'User'
      click_button 'Register'

      page.should_not have_content('You must provide a last name')
    end

    it 'validates email' do
      page.should have_content('You must provide an email')
      page.should have_content('You must provide an email confirmation')

      fill_in 'user_email', with: 'web.user@example.com'
      fill_in 'user_email_confirmation', with: 'web.use@example.com'
      click_button 'Register'

      page.should_not have_content('You must provide an email')
      page.should_not have_content('You must provide an email confirmation')
    end

    it 'validates password' do
      page.should have_content('You must provide an password')
      page.should have_content('You must provide an password confirmation')

      within '#registration-form' do
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'pass'
        click_button 'Register'
      end

      page.should_not have_content('You must provide an password')
      page.should_not have_content('You must provide an password confirmation')
    end
    
    it 'confirms email' do
      within '#registration-form' do
        fill_in 'user_email', with: 'wu@example.com'
        fill_in 'user_email_confirmation', with: 'w@example.com'
        click_button 'Register'
      end

      page.should have_content('Your emails do not match.')

      within '#registration-form' do
        fill_in 'user_email', with: 'wu@example.com'
        fill_in 'user_email_confirmation', with: 'wu@example.com'
        click_button 'Register'
      end

      page.should_not have_content('Your emails do not match.')
    end

    it 'confirms password' do
      within '#registration-form' do
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'pass'
        click_button 'Register'
      end

      page.should have_content('Your passwords do not match.')

      within '#registration-form' do
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'Register'
      end

      page.should_not have_content('Your passwords do not match.')
    end
  end
end
