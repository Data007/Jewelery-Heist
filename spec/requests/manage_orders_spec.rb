require 'spec_helper'

describe 'Orders' do

  before do
    @admin = Factory.create :admin

    @customer = Factory.create :customer, phones: ['231-884-3024'], emails: ['customer_1@example.net']
    @customer.addresses.create!({
      address_1:   '1 CIRCULAR DR',
      city:        'LOGIC',
      province:    'MI',
      postal_code: '49601'
    })

    login_admin(@admin, 'password')
    visit admin_user_path(@customer)

    current_path.should == admin_user_path(@customer.id)
  end

  it 'creates an order' do
    click_link 'In Store Purchase'

    @customer.reload
    @order = @customer.orders.last
    
    current_path.should == admin_user_order_path(@customer.id, @order.id)
    page.should have_content('Line Items')
    page.should have_content('Payments')
    page.should have_content("Instore Purchase ##{@order.id}")

    click_button 'save line items'
    current_path.should == admin_user_order_path(@customer.id, @order.id)
  end

  it 'shows an order'
  
  context 'items' do

    before do
      @item  = Factory.create(:item, name: 'Test Item')
      @item.variations.create(price: 30)
    end

    it 'adds a quick item', js: true do
      @order = @customer.orders.create

      visit admin_user_order_path(@customer.id, @order.id)

      click_on 'add a quick line item'
      fill_in  'Name', with: 'test quick item'
      fill_in  'Price', with: '30.00'
      uncheck  'Taxable?'
      click_on 'add new line item'

      current_path.should == admin_user_order_path(@customer.id, @order.id)
      page.should have_content('test quick item')

      @customer.reload
      @order     = @customer.orders.find(@order.id)
      @line_item = @order.line_items.first
      
      @line_item.should              be
      @line_item.price.should        == 30.00
      @line_item.taxable.should_not be
    end

    it 'adds a stock item' do
      visit admin_user_path(@customer.id)

      click_on 'In Store Purchase'

      @customer.reload
      @order = @customer.orders.last
      @order.line_items.empty?.should be

      fill_in  'search_query', with: 'Test'
      click_on 'search'
      click_on 'Test Item'
      click_on 'Add to Cart'

      current_path.should == admin_user_order_path(@customer.id, @order.id)
      page.should have_content('Test Item')

      @customer.reload
      @order     = @customer.orders.find(@order.id)
      @line_item = @order.line_items.first
      
      @line_item.should          be
      @line_item.price.should    == 30.00
      @line_item.taxable.should be
    end

  end

  context 'payments', js: true do

    before do
      @order = @customer.orders.create purchased: true
      @item  = Factory.create(:item, name: 'Test Item')
      @item.variations.create(price: 30)
      @order.add_item @item.variations.last

      visit admin_user_order_path(@customer.id, @order.id)
    end

    it 'adds a partial payment' do
      click_on 'add a payment'
      fill_in  'Amount', with: 15
      click_on 'add new payment'

      current_path.should == admin_user_order_path(@customer.id, @order.id)

      @customer.reload
      @order = @customer.orders.find(@order.id)

      @order.paid.should    == 15
      @order.balance.should == 16.8
    end

    it 'adds a full payment' do
      click_on 'add a payment'
      fill_in  'Amount', with: @order.total
      click_on 'add new payment'

      current_path.should == admin_user_order_path(@customer.id, @order.id)

      @customer.reload
      @order = @customer.orders.find(@order.id)

      @order.paid.should    == @order.total
      @order.balance.should == 0
    end

    it 'applies in store credit' do
      order = @customer.orders.create purchased: true
      order.payments.create payment_type: 'instore credit', amount: -15

      @customer.reload
      @order   = @customer.orders.find(@order.id)
      @customer.total_credits.should == 15
      @customer.total_balance.should == 16.8

      click_on 'add a payment'
      select   'Instore Credit', from: 'Payment Type'
      fill_in  'Amount', with: 15
      click_on 'add new payment'

      current_path.should == admin_user_order_path(@customer.id, @order.id)

      @customer.reload
      @order = @customer.orders.find(@order.id)

      @order.paid.should             == 15
      @order.balance.should          == 16.8
    end

    it 'pays off an order' do
      # add an initial payment
      click_on 'add a payment'
      fill_in  'Amount', with: 15
      click_on 'add new payment'

      current_path.should == admin_user_order_path(@customer.id, @order.id)

      @customer.reload
      @order = @customer.orders.find(@order.id)

      @order.paid.should    == 15
      @order.balance.should == 16.8

      # pay it off
      click_on 'add a payment'
      fill_in  'Amount', with: @order.balance
      click_on 'add new payment'

      current_path.should == admin_user_order_path(@customer.id, @order.id)

      @customer.reload
      @order = @customer.orders.find(@order.id)

      @order.paid.should    == @order.total
      @order.balance.should == 0
    end
  
  end

  it 'adds a note' do
    order = @customer.orders.create purchased: true
    visit admin_user_order_path(@customer.id, order.id)

    fill_in  'Note', with: 'I should add some items eventually'
    click_on 'update order notes'

    @customer.reload
    order = @customer.orders.find(order.id)
    order.notes.should == 'I should add some items eventually'
    current_path.should == admin_user_order_path(@customer.id, order.id)
    page.should have_content('I should add some items eventually')
  end

  context 'print'
  context 'ticket'

end
