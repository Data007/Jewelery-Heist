require 'spec_helper'

describe Cart do
  use_vcr_cassette
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

        context 'with an taxable item' do
          before do
            @cart = FactoryGirl.create :anonymous_cart_ready_for_payments
            @cart.add_item @item
            @cart.reload
            @cart.line_items.first.taxable = true
            @cart.save!
            @cart.reload
          end

          it 'gets a total 'do
            #2x item.price = 10, Fedex Ground = 15.27 + .60 tax
            @cart.line_items.count.should == 2
            @cart.total.should == "$" + (@cart.subtotal + @cart.get_rate.total_net_charge.to_f + @cart.tax).to_s

            @cart.shipping_type = 'Ups Ground'
            @cart.total.should == "$" + ((@cart.subtotal + (@cart.individual_ups_rate.to_f / 100) + @cart.tax).round(2)).to_s
          end

          it 'gets a rate' do
            fedex_rate = @cart.get_rate('FEDEX_EXPRESS_SAVER')
            fedex_rate.should be

            ups_rate = @cart.individual_ups_rate 
            ups_rate.should be
          end

          it 'gets a ups rate' do
            @cart.shipping_type = 'UPS Ground'
            @cart.individual_ups_rate.should be
          end
        end
      end

      it 'removes an item'
    end
  end

  context 'with a a shipping address' do
    before do
      @cart = FactoryGirl.create :anonymous_cart_ready_for_payments
    end
  end
end
