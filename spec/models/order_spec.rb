require 'spec_helper'

describe Order do
  
  before do
    @user      = Factory.create(:customer)
    @item      = Factory.create(:item)
    @variation = @item.variations.create
  end

  it 'adds from line item hash' do
    line_item = Factory.build(:line_item, variation: @variation)
    order     = @user.orders.create

    order.add_line_item line_item
    order.line_items.should include(line_item)

    @user.reload
    order = @user.orders.find(order.id)

    order.line_items.should include(line_item)
  end

  context 'Item' do

    before do
      @order = @user.orders.create
    end

    it 'adds from a variation' do
      pending 'needs refactored since there are no more variations'
      variation = @item.variations.create name: 'Adds from Variation Hash'
      
      @order.add_item variation, size: 8.5

      @user.reload
      @order    = @user.orders.find(@order.id)
      line_item = @order.line_items.map {|li| li if li.variation.id == variation.id}.first
      variation = line_item.variation
      item      = variation.parent_item

      line_item.should be
      variation.should be
      item.should      be
  
      line_item.size.should == 8.5
    end

  end

end
