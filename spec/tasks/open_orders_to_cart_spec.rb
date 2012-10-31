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
      @user.cart.should be
    end
 end
end
