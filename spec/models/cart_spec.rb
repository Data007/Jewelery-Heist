require 'spec_helper'

describe Cart do
  context ' with a cart' do
    before do
      @cart = FactoryGirl.create :cart
    end

    it 'validates handling method' do
      @cart.handling.should == 5
    end

    context 'with an item' do
      before do
        @item = FactoryGirl.create :item
      end

      context 'adds an item' do
        it 'from an item object' do
          @cart.line_items.count.should == 0
          @cart.add_item @item

          @cart.reload
          @cart.line_items.count.should == 1
          @cart.line_items.first.price.should == @item.price
        end

        it 'from an item id' do
          @cart.line_items.count.should == 0
          @cart.add_item @item.id

          @cart.reload
          @cart.line_items.count.should == 1
          @cart.line_items.first.price.should == @item.price
        end

        it 'from an item with options' do
          @cart.line_items.count.should == 0
          @cart.add_item @item, {size: '6'}

          @cart.reload
          @cart.line_items.count.should == 1

          line_item = @cart.line_items.first
          line_item.price.should == @item.price
          line_item.size.should  == 6
        end
      end

      it 'removes an item'
    end
  end
end
