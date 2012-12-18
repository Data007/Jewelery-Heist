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
      before do
        fill_in 'Employee ID', with: employee.pin
        click_button 'Enter'
      end

      context 'purchasing an item' do
        it 'fails to find an item by id' do
          fill_in 'Item Number', with: 'id30'
          click_button 'Enter'

          page.should have_content('That item could not be found')
        end

        it 'finds an item by id'
      end

      context 'with no customer'
      context 'with a current customer'
    end
  end
end
