require 'spec_helper'

describe 'Manage Gallery' do
  
  before do

    4.times.each do |i|
      FactoryGirl.create :item
    end

    @item         = FactoryGirl.create :item
    @gallery_item = FactoryGirl.create :item, in_gallery: true

    @admin = FactoryGirl.create :admin
    login_admin(@admin, 'password')

  end

  context 'not in the gallery' do
    
    it 'is put into the gallery' do
      Item.in_gallery.count.should == 1

      visit edit_admin_item_path(@item.pretty_id)
      check 'In gallery'
      click_button 'save'

      Item.in_gallery.count.should == 2
    end

  end

  context 'in the gallery' do
    
    it 'is pulled out of the gallery' do
      Item.in_gallery.count.should == 1

      visit edit_admin_item_path(@gallery_item.pretty_id)
      uncheck 'In gallery'
      click_button 'save'

      Item.in_gallery.count.should == 0
    end

  end

end
