require 'spec_helper'

describe 'Dashboard' do
  
  before do
    @user  = FactoryGirl.create :web_user
    @item  = FactoryGirl.create :item
    @order = FactoryGirl.create :order, user: @user
    @payment = FactoryGirl.create :payment, order: @order

    login_with_dh @user.email, 'password'
  end

  it 'Shows the dashboard after login' do
    current_url.should == url_for([:account])
  end
  
  context 'cart' do
    it 'shows an item in my cart' do
      visit '/'
      click_link @item.name
      click_link 'Add to Cart'
      click_link 'Account'

      within '#current-cart' do
        page.should have_css('.items .item')
        all('.items .item').count.should == 1
        page.should have_content(@item.description)
      end
    end
  end
  
  context 'orders' do
    it 'shows my past orders'
  end

  context 'payments' do
    it 'shows my past payments' do
      within '#payment-history' do
        page.should have_css('.payments .payment')
        all('.payments .payment').count.should == 1
        page.should have_content(@payment.order.pretty_id)
        page.should have_content(@payment.created_at)
        page.should have_content(@payment.payment_type)
        page.should have_content(@payment.amount)
      end
    end
  end
end
