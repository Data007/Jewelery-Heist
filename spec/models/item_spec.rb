require 'spec_helper'

describe Item do
  context '#find' do
    before do
      @item = FactoryGirl.create :item
    end

    it 'finds an item with a pretty id' do
      Item.find(@item.pretty_id).should == @item
    end

    it 'finds an item with a bson object id'
  end
end
