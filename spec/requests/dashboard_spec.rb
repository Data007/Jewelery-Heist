require 'spec_helper'

describe 'Dashboard' do
  
  before do
    @user  = FactoryGirl.create :web_user
    @item  = FactoryGirl.create :item
    @order = FactoryGirl.create :order, user: @user
    @address = FactoryGirl.create :address, order: @order 
    @invoice = FactoryGirl.create :invoice, order: @order
    @payment = FactoryGirl.create :payment, invoice: @invoice

    login_with_dh @user.email, 'password'
  end

  it 'Shows the dashboard after login' do
    current_url.should == url_for([:account])
  end
  
  context 'cart' do
    it 'shows an item in my cart' do
      pending 'anon cart foepa'
      visit '/'
      click_link @item.name
      click_button 'Add to Cart'
      click_link 'Account'

      within '#current-cart' do
        page.should have_css('.items .item')
        all('.items .item').count.should == 1
        page.should have_content(@item.description)
      end
    end
  end
  
  context 'orders' do
    it 'shows my past orders' do
      within '#order-history' do
        page.should have_css('.orders .order')
        all('.orders .order').count.should == 1
        # page.should have_content(@order)
      end
    end

    it 'has an order view' do
      click_link @order.pretty_id.to_s
      current_url.should == user_order_url(@user.pretty_id, @order.pretty_id)
      within '#order-history' do
        page.should have_content('Shipping Address')
        page.should have_content('Items')
        page.should have_content('Description')
        page.should have_content('Price')
        page.should have_content('Tax')
        page.should have_content('Shipping')
        page.should have_content('Total')
        page.should have_content('Paid')
        page.should have_content('Payments')
        page.should have_content('Paid On')
        page.should have_content('Paid With')
        page.should have_content('Amount')
      end
    end
  end

  context 'payments' do
    it 'shows my past payments' do
      within '#payment-history' do
        page.should have_css('.payments .payment')
        all('.payments .payment').count.should == 1
        page.should have_content(@payment.invoice.order.pretty_id)
        page.should have_content(localize(@payment.created_at, format: :long))
        page.should have_content(@payment.payment_type)
        page.should have_content(@payment.amount)
      end
    end
  end

  context 'in the dashboard editing phone numbers' do
    it 'adds a phone number'
  end
end
