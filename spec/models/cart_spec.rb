require 'spec_helper'

describe Cart do
  context ' with a cart' do
    before do
      @cart = FactoryGirl.create :cart
    end

    it 'validates handling method' do
      @cart.handling.should == 5
    end
  end
end
