require 'spec_helper'

describe 'Manage Items' do
  
  before do
    @admin = Factory.create :admin
    login_admin(@admin, 'password')
  end

  it 'creates an item' do
    Item.count.should == 0

    visit new_admin_item_path
    
    fill_in 'Name',            with: 'Test Item'
    fill_in 'Description',     with: 'Test item description'
    fill_in 'Price',           with: '30.56'
    fill_in 'Quantity',        with: '1'
    fill_in 'Size range',      with: '3-6'
    fill_in 'Backorder notes', with: 'Custom orders only available'
    fill_in 'Metals',          with: 'sterling silver'
    fill_in 'Finishes',        with: 'polished'
    fill_in 'Gems',            with: 'emerald'
    check   'Published'
    check   'Available'
    click_button 'save'
    
    Item.count.should == 1
    item = Item.first

    current_path.should == edit_admin_item_path(item.pretty_id)
    page.should have_content('Test Item has been created for you.')
    page.should have_content("Editing #{item.name.titleize} (ID#{item.pretty_id})")

    click_link 'view'
    current_path.should == admin_item_path(item.pretty_id)
  end

end
