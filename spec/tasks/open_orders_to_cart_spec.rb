require 'spec_helper'
require 'rake'

describe 'Open Orders are moved to carts' do
  before do
    @user = FactoryGirl.create :web_user_with_order
    @order = @user.orders.first
  end

  context 'with an order 'do
    it 'moves open orders to a cart' do
      @user.orders.should be
      @user.cart.should_not be

      execute_rake('order.rake', 'order_to_cart')

      @user.reload
      cart = @user.cart
      cart.should be

      cart.first_name.should == @user.first_name
      cart.last_name.should == @user.last_name
      cart.email.should == @user.email
      cart.current_stage.should == 'checkout'
      cart.shipping_address.should == @order.address
      cart.line_items.should == cart.line_items + @order.line_items
    end
 end
end
