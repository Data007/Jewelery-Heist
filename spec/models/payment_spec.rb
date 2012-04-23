require 'spec_helper'

describe Payment do

  before do
    @customer = FactoryGirl.create :customer, phones: ['231-884-3024'], emails: ['customer_1@example.net']
    @customer.addresses.create!({
      address_1:   '1 CIRCULAR DR',
      city:        'LOGIC',
      province:    'MI',
      postal_code: '49601'
    })

    @order    = @customer.orders.create
    @item     = FactoryGirl.create :item, name: 'test', price: 20
    @order.add_item @item
  end

  it 'refunds a payment' do
    payment = @order.add_payment 10
    
    @customer.reload
    @order = @customer.orders.find(@order.id)
    
    @order.payments.count.should == 1
    @order.payments.should include(payment)
    @order.paid.should    == payment.amount
    @order.balance.should == @order.total - payment.amount

    payment.refund

    @customer.reload
    @order = @customer.orders.find(@order.id)
    
    @order.payments.count.should == 2
    @order.paid.should    == 0
    @order.balance.should == @order.total
  end

end
