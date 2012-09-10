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

    it 'validates email'
    it 'validates password'
    
    it 'confirms email'
    it 'confirms password'
  end
end
