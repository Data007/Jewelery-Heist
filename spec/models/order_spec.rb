require 'spec_helper'

describe Order do
  
  before do
    @user      = Factory.create(:customer)
    @item      = Factory.create(:item, variations: [Factory.create(:variation)])
    @variation = @item.variations.first
  end

  context 'Line Item' do

    it 'adds from line item hash' do
      line_item = Factory.build(:line_item, variation: @variation)
      order     = @user.orders.create

      order.add_line_item line_item
      order.line_items.should include(line_item)

      @user.reload
      order = @user.orders.last

      order.line_items.should include(line_item)
    end

    it 'adds from a line item class'

  end

  it 'adds an item'
end
