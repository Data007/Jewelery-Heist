require 'spec_helper'

describe 'Managing Sales' do
  let!(:employee) {FactoryGirl.create :user, role: 'employee'}
  let!(:item)     {FactoryGirl.create :item}

  context 'create a sale' do
    before do
      visit '/manage'
      click_link 'Sale'
    end

    context 'requires an employee pin' do
      before do
        current_path.should == '/manage/authorize'
      end

      it 'rejects invalid pins' do
        fill_in 'Employee ID', with: '3242535'
        click_button 'Enter'

        page.should have_content('That is an invalid ID')
      end

      it 'finds employee with a valid pin' do
        fill_in 'Employee ID', with: employee.pin
        click_button 'Enter'

        page.should_not have_content('That is an invalid ID')
        current_path.should == '/manage/sales/new'
      end
    end

    context 'with a valid pin' do
      pending 'valid pin test'
      context 'with a new customer' do
      end
    end
  end
end
